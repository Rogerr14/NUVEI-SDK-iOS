//
//  Loading.swift
//  NuveiDemoAPP
//
//  Created by Jorge on 23/7/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                Text("Loading...")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .padding(.top, 10)
            }
            .padding(20)
            .background(.gray.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    LoadingView()
}
