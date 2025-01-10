//
//  HP_TriviaApp.swift
//  HP Trivia
//
//  Created by Paul F on 23/10/24.
//

import SwiftUI

@main
struct HP_TriviaApp: App {
    //V-105,paso 202
    @StateObject private var store = Store()
    //V-109,paso 226
    @StateObject private var game = Game()
    var body: some Scene {
        WindowGroup {
            ContentView()
                //Paso 203
                .environmentObject(store)
                //Paso 227
                .environmentObject(game)
                //V-107,paso 218 agregamos el task
                .task{
                    //tan pronto habra la app ,cargamos los productos.
                    await store.loadProducts()
                    //V-114,Paso 279 cargamos los puntuajes
                    game.loadScores()
                    //Paso 285
                    store.loadStatus()
                }
        }
    }
}
