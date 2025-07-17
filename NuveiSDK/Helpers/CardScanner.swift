//
//  CardScanner.swift
//  NuveiSDK
//
//  Created by Jorge on 16/7/25.
//
import Foundation
import Vision
import VisionKit
import UIKit

@available(iOS 15.0, *)
public class CardScanner: NSObject {
    private var callback: ((Bool, CardModel?) -> Void)?
    private weak var viewController: UIViewController?
    
    /// Inicia el escaneo de una tarjeta de crédito usando la cámara
    /// - Parameters:
    ///   - viewController: El controlador desde el cual se presenta el escáner
    ///   - callback: Closure que devuelve si el escaneo fue cancelado y el objeto PaymentCard (si se escaneó correctamente)
    public func showScan(_ viewController: UIViewController, callback: @escaping (Bool, CardModel?) -> Void) {
        self.callback = callback
        self.viewController = viewController
        
        // Verificar permiso de cámara
//        guard AVCaptureDevice.authorizationStatus(for: ) == .authorized else {
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                DispatchQueue.main.async {
//                    if granted {
//                        self.presentScanner()
//                    } else {
//                        callback(true, nil) // Cancelado por falta de permisos
//                    }
//                }
//            }
//            return
//        }
        
        presentScanner()
    }
    
    private func presentScanner() {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = self
        viewController?.present(scanner, animated: true, completion: nil)
    }
}

@available(iOS 15.0, *)
extension CardScanner: VNDocumentCameraViewControllerDelegate {
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true, completion: nil)
        
        // Procesar la imagen escaneada
        guard scan.pageCount > 0 else {
                    callback?(false, nil)
                    return
                }
        let image = scan.imageOfPage(at: 0)
        // Configurar la solicitud de Vision para OCR
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let self = self, let results = request.results as? [VNRecognizedTextObservation], error == nil else {
                self?.callback?(false, nil)
                return
            }
            
            // Extraer texto de la imagen
            let recognizedText = results.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
            let cardInfo = self.extractCardInfo(from: recognizedText)
            self.callback?(false, cardInfo)
        }
        
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US"]
        
        // Procesar la imagen con Vision
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
              do {
                  try handler.perform([request])
              } catch {
                  callback?(false, nil)
              }
    }
    
    public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true, completion: nil)
        callback?(true, nil)
    }
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true, completion: nil)
        callback?(false, nil)
    }
    
    private func extractCardInfo(from text: String) -> CardModel? {
        // Extraer número de tarjeta (busca secuencias de 13-19 dígitos)
        let cardNumberRegex = try? NSRegularExpression(pattern: "\\b\\d{13,19}\\b", options: [])
        guard let cardNumberMatch = cardNumberRegex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)),
              let cardNumberRange = Range(cardNumberMatch.range, in: text) else {
            return nil
        }
        let cardNumber = String(text[cardNumberRange]).replacingOccurrences(of: " ", with: "")
        
        // Extraer fecha de vencimiento (formato MM/YY o MM/YYYY)
        let expiryRegex = try? NSRegularExpression(pattern: "\\b(0[1-9]|1[0-2])[/\\s]([0-9]{2}|[0-9]{4})\\b", options: [])
        var expiryMonth: Int?
        var expiryYear: Int?
        if let expiryMatch = expiryRegex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)),
           let expiryRange = Range(expiryMatch.range, in: text) {
            let expiry = String(text[expiryRange]).split(separator: "/")
            if expiry.count == 2 {
                expiryMonth = Int(expiry[0])
                expiryYear = Int(expiry[1])
                if expiryYear ?? 0 < 100 { // Convertir YY a YYYY
                    expiryYear = (expiryYear ?? 0) + 2000
                }
            }
        }
        
        // Extraer nombre del titular (simplificado: asumir texto con letras y espacios)
        let nameRegex = try? NSRegularExpression(pattern: "[A-Za-z\\s]{2,}", options: [])
        let nameMatch = nameRegex?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        let cardHolder = nameMatch?.compactMap { Range($0.range, in: text).map { String(text[$0]) } }.first ?? "Unknown"
        
        // Extraer CVC (simplificado: buscar 3-4 dígitos cerca de la fecha)
        let cvcRegex = try? NSRegularExpression(pattern: "\\b\\d{3,4}\\b", options: [])
        let cvc = cvcRegex?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
            .compactMap { Range($0.range, in: text).map { String(text[$0]) } }
            .first(where: { $0 != cardNumber }) ?? "123"
        
        // Crear objeto PaymentCard
        return CardModel.createCard(
            cardHolderName: cardHolder,
            cardNumber: cardNumber,
            expiryMonth: expiryMonth ?? 12,
            expiryYear: expiryYear ?? Calendar.current.component(.year, from: Date()),
            cvc: cvc
        )
    }
}
