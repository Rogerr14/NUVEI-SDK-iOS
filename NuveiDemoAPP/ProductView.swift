//
//  ProdcutView.swift
//  NuveiDemoAPP
//
//  Created by Jorge on 22/7/25.
//

import SwiftUI
import NuveiSDK

struct ProductView:View {
    @State var cardSelected: CardModel?
    var body: some View {
        NavigationStack{
            
            
            VStack{
                ItemsView(nameIcon: "bag", description: "coffe", price: 10)
                ItemsView(nameIcon: "bag", description: "Chocolate Cake", price: 3.2)
                ItemsView(nameIcon: "bag", description: "Gourmet salad", price: 12.99)
                Spacer(minLength: 10)
                NavigationLink(destination: ListCardView()){
                    HStack{
                        Image(uiImage: UIImage(named: "cc_Amex", in: Bundle(for: NuveiSdk.self), with: nil) ?? UIImage())
                        VStack(alignment: .leading){
                            Text((cardSelected != nil ? cardSelected?.cardNumber  :"Agregar Tarjeta") ?? "Agregar Tarjetas")
                            Text((cardSelected != nil ? cardSelected?.cardHolderName  :"Debe agregar una tarjeta para continuar") ?? "Debe agregar una tarjeta para continuar")
                        }
                        .foregroundStyle(.black)
                        .padding(.horizontal, 20)
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                    }
                    .padding(40)
                    .background(.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Spacer()
                
            }
            .toolbar{
                ToolbarItem(placement: .principal) {
                    Image("nuvei")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}



struct ItemsView:View{
    var nameIcon: String
    var description: String
    var price: Double
    
    var body: some View{

            HStack{
                Image(systemName: nameIcon)
                Text(description).frame(maxWidth: .infinity)
                Text(price, format: .currency(code: "USD"))
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
    }
    
}

#Preview{
    ProductView(cardSelected: nil)
}
