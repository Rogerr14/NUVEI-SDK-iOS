//
//  CardViewForm.swift
//  NuveiSDK
//
//  Created by Jorge on 17/7/25.
//
import Foundation
import SwiftUI

struct CardViewForm: View {
    
    enum FocusedField{
            case cvcText, dateText
    }
    @State var numberCard: String = ""
    @State var holderCard: String = ""
    @State var dateExpiration: String = ""
    @State var cvcCode: String = ""
    @FocusState var focuseField: FocusedField?
    @State var cardtype: PaymentCardType = .notSupported

    var body: some View {
        VStack {
            
           
            ZStack{
                Rectangle().foregroundStyle(.gray.opacity(0.8))
                ImageViewCustom(imagePath: GlobalHelper.getCardTypeAsset(cardType: cardtype)).position(CGPoint(x: 50, y: 40 ))
                VStack{
                    
                    
                    Text("\(numberCard.isEmpty ? "**** **** **** *****": numberCard)")
                    HStack{
                        VStack{
                            Text("Name of Cardholder".localized)
                            Text("")
                        }
                        VStack{
                            Text("Expiration (MM/YY)".localized)
                            Text("")
                        }
                    }
                }
                
            }.frame(width:.infinity, height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            CustomTextField(text: $holderCard, placeholder: "Name of Cardholder", cornerRadius: 5)
            CustomTextField(text: $numberCard, placeholder: "Card Number").onChange(of: numberCard) { oldValue, newValue in
                cardtype = GlobalHelper.getTypeCard(newValue)
            }
            HStack{
                CustomTextField(text: $dateExpiration, placeholder: "Expiration (MM/YY)")
                CustomTextField(text: $cvcCode, placeholder: "CVC").focused($focuseField, equals: .cvcText,)
            }
            
        }
        .padding()
            .border(.black, width: 1)
    }
}

#Preview {
    CardViewForm()
}
