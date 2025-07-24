//
//  ContentView.swift
//  NuveiDemoAPP
//
//  Created by Jorge on 16/7/25.
//

import SwiftUI
import NuveiSDK

struct ContentView: View {
    @State private var currentScreen: Screen = .screen1
    
    
    enum Screen{
        case screen1
        case screen2
    }
    
    var body: some View {
        ZStack{
            
            
            switch currentScreen {
            case .screen1:
                SimulationScreen(startSimulation: {currentScreen = .screen2})
            case .screen2:
                ProductView().transition(.blurReplace)
                
                
            }
        }.animation(.easeInOut(duration: 0.3), value: currentScreen)
    }
}


struct SimulationScreen: View{
    var startSimulation: () -> Void
    var body: some View{
        VStack{
            HStack{
                Image("nuvei")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                Text("sdk")
                    .fontWidth(Font.Width(10))
            }
            Button {
                print(Constants().appCode)
                NuveiSdk.initEnvironment(appCode: Constants().appCode, appKey: Constants().appKey, serverCode: Constants().serverCode, serverKey: Constants().serverKey, testMode: true)
                startSimulation()
            } label: {
                Text("Start Simulation")
                    .foregroundStyle(.white)
                    .padding(20)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    
            }

        }
    }
}


#Preview {
    ContentView()
}
