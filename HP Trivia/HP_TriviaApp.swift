//
//  HP_TriviaApp.swift
//  HP Trivia
//
//  Created by Paul F on 23/10/24.
//

import SwiftUI

@main
struct HP_TriviaApp: App {
    //Vid 119
    @StateObject private var store = Store()
    //Vid 123
    @StateObject private var game = Game()
    var body: some Scene {
        WindowGroup {
            ContentView()
            //Vid 119
                .environmentObject(store)
            //Vid 123
                .environmentObject(game)
                //Vid 121
                .task{
                    //tan pronto habra la app ,cargamos los productos.
                    await store.loadProducts()
                    //Vid 128, cargamos los puntuajes
                    game.loadScores()
                    store.loadStatus()
                }
        }
    }
}
