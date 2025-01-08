//
//  Constands.swift
//  HP Trivia
//
//  Created by Paul F on 23/10/24.
//



import Foundation
import SwiftUI

enum Constants{
    //Vid 91,Paso 6 importamos nuestra fuente de texto.
    static let hpFont = "PartyLetPlain"
    //Vid 122
    static let previewQuestion = try! JSONDecoder().decode([Question].self, from: Data(contentsOf: Bundle.main.url(forResource: "trivia", withExtension: "json")!))[0]
}

//Vid 108
struct InfoBackgroundImage:View {
    var body:some View {
        Image("parchment")
            .resizable()
            .ignoresSafeArea()
            .background(.brown)
    }
}

extension Button{
    func doneButton()->some View{
        self
            .font(.largeTitle)
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(.brown)
            .foregroundColor(.white)
    }
}

//Vid 128,Paul Hudson
extension FileManager{
    static var documentsDirectory:URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
