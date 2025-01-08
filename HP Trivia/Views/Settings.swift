//
//  Settings.swift
//  HP Trivia
//
//  Created by Paul F on 23/10/24.
//

import SwiftUI



struct Settings: View {
    @Environment(\.dismiss) private var dismiss
    //Vid 119
    @EnvironmentObject private var store: Store
 
    
    var body: some View {
        ZStack{
            InfoBackgroundImage()
            VStack{
                Text("Wich books would you like to see questions form ?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                ScrollView{
                    LazyVGrid(columns:[GridItem(),GridItem()]){
                        
                        //Vid 110
                        ForEach(0..<7){i in
                            
                            if store.books[i] == .active || (store.books[i] == .locked
                                                              && store.purchasedIDs.contains("hp\(i+1)"))
                            {
                                ZStack(alignment: .bottomTrailing){
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundColor(.green)
                                        .shadow(radius: 1)
                                        .padding(3)
                                }
                                //Vid 121
                                .task{
                                    store.books[i] = .active
                                    //Vid 128
                                    store.saveStatus()
                                }
                                .onTapGesture {
                                    store.books[i] = .inactive
                                    //Vid 128
                                    store.saveStatus()
                                }
                                
                            }else if store.books[i] == .inactive {
                                ZStack(alignment: .bottomTrailing){
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay(Rectangle().opacity(0.33))
                                    
                                    Image(systemName: "circle")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundColor(.green
                                            .opacity(0.5))
                                        .shadow(radius: 1)
                                        .padding(3)
                                }
                                .onTapGesture{
                                    store.books[i] = .active
                                    //Vid 128
                                    store.saveStatus()
                                }
                                
                            }else {
                                //Vid 109, libro con candado
                                ZStack{
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay(Rectangle().opacity(0.75))
                                    
                                    Image(systemName: "lock.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .shadow(color:
                                                .white.opacity(0.75),
                                                radius: 3)
                                }//zstack
                                .onTapGesture {
                                    //el 3 es el libro numero 4 bloqueado
                                    let product = store.products[i-3]
                                    
                                    Task {
                                        await
                                        store.purchase(product)
                                    }
                                    
                                }
                                
                            }//else
                        }//for each
                    }
                }.padding()
                
                Button("Done"){
                    dismiss()
                }
                .doneButton()
            }
            .foregroundColor(.black)
        }
    }
}

#Preview {
    Settings()
}
