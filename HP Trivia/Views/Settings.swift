//
//  Settings.swift
//  HP Trivia
//
//  Created by Paul F on 23/10/24.
//

import SwiftUI

//V-95,Paso 60 creamos esta nueva ventana
struct Settings: View {
    //Paso 63
    @Environment(\.dismiss) private var dismiss
    //Paso 
    @EnvironmentObject private var store: Store
 
    var body: some View {
        ZStack{
            //paso 61, ponemos el background
            InfoBackgroundImage()
            //Paso 64
            VStack{
                Text("Wich books would you like to see questions form ?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                //Paso 65 add scroll
                ScrollView{
                    //Paso 69
                    LazyVGrid(columns:[GridItem(),GridItem()]){
                
                        //V-96,paso 76,add For each
                        ForEach(0..<7){i in
                            //Paso 77, si el libro esta activo
                            if store.books[i] == .active || (store.books[i] == .locked
                                                              && store.purchasedIDs.contains("hp\(i+1)"))
                            {
                                //Paso 71, ponemos alignment: .bottomTrailing
                                ZStack(alignment: .bottomTrailing){
                                    //Paso 78,"hp\(i+1)"
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                    //Para el circulo verde
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
                                //Paso 82
                                .onTapGesture {
                                    store.books[i] = .inactive
                                    //Vid 128
                                    store.saveStatus()
                                }
                                //Paso 79,store.books[i] == .inactive
                            }else if store.books[i] == .inactive {
                                //Paso 72,para el libro no seleccionado
                                ZStack(alignment: .bottomTrailing){
                                    //Paso 80,hp\(i+1)
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
                                //Paso 83
                                .onTapGesture{
                                    store.books[i] = .active
                                    //Vid 128
                                    store.saveStatus()
                                }
                                
                            }else {
                                //Paso 73,para el libro con candado
                                ZStack{
                                    //Paso 81,hp\(i+1)
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
                }
                //Paso 70 ,add el padding
                .padding()
                //Paso 62
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
