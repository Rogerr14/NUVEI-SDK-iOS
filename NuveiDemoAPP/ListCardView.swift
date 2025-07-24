        //
        //  ListCardView.swift
        //  NuveiDemoAPP
        //
        //  Created by Jorge on 23/7/25.
        //

        import SwiftUI
        import NuveiSDK

        struct ListCardView: View {
            @State var isLoading: Bool =  true
            @State var listCards: [CardModel] = []
            @State var errorMessage: String?
            
            @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

            
            var btnBack : some View { Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                        Image(systemName: "chevron.backward")
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.black)
                         
                        }
                    }
                }
            
            var body: some View {
                
                NavigationStack{
                ZStack {
                    VStack{
                        List(listCards) {card in
                            HStack{
                                card.cardImage
                                VStack{
                                    Text("···· ···· \(String(describing: card.cardNumber))")
                                    Text(card.cardHolderName)
                                }
                                Spacer()
                                Image(systemName: "trash")
                            }
                            
                        }
                        Spacer()
                            NavigationLink(destination: AddCardView()){
                                Text("Add Card")
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(20)
                                
                                   
                                    .background(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(20)
                            }
                        
                        
                        
                    }
                    .toolbar{
                        ToolbarItem(placement: .principal) {
                            Image("nuvei")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: btnBack)
                    
                    if isLoading{
                        LoadingView()
                    }
                }}
                .onAppear{
                    Task{
                        await loadListCards()
                    }
                    
                }
            }
            private func loadListCards() async {
                isLoading = true
                defer { isLoading = false }
                do {
                        let data = try await NuveiSdk.listCardAvaliables(uid: "4")
                        listCards = data
                        errorMessage = nil
                    print("todo ok")
                } catch let error as GeneralErrorModel {
                    print(error)
                    errorMessage = error.error.help
                    } catch {
                        
                        errorMessage = "Error inesperado: \(error)"
                    }
                print(errorMessage)
             
                
            }
        }

        #Preview {
            ListCardView( listCards: [])
        }
