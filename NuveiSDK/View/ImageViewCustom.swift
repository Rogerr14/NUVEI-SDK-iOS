//
//  ImageViewCustom.swift
//  NuveiSDK
//
//  Created by Jorge on 28/7/25.
//

import SwiftUI

struct ImageViewCustom: View {
    let imagePath:String
    var body: some View {
        Image(uiImage: UIImage(named:  imagePath, in: Bundle(for: CardModel.self), with: nil, ) ?? UIImage())
    }
}
