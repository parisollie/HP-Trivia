//
//  Game.swift
//  HP Trivia
//
//  Created by Paul F on 25/10/24.
//

import Foundation
//Para animaciones
import SwiftUI

//V-109,Paso 225, ver el video de nuevo es mucha teoria
@MainActor
class Game : ObservableObject{
    //Paso 230
    private var allQuestions: [Question] = []
    //Paso 236
    private var answeredQuestions: [Int] = []
    //Vid 124
    var answer:[String] = []
    //Paso 276
    private let savePath = FileManager.documentsDirectory.appending(path: "SavedScores")
    //Paso 231
    var filteredQuestions: [Question] = []
    //Paso 235
    var currentQuestion = Constants.previewQuestion
    
    var answers:  [String] = []
    
    //Paso 244, computer propert para saber la respuesta correcta,queremos la key
    var correctAnswer: String{
        currentQuestion.answers.first(where:{$0.value == true})!.key
    }
    
    //V-111,Paso 245
    @Published var gameScore = 0
    @Published var questionScore = 5
    @Published var recentScores = [0,0,0]
    
    //Paso 233
    init (){
        decodeQuestions()
    }
    //Paso 246
    func startGame(){
        gameScore = 0
        questionScore = 5
        answeredQuestions = []
    }
    //Paso 234, para las preguntas que selecciono el usuario
    func filterQuestions(to books: [Int]){
        filteredQuestions = allQuestions.filter{books.contains($0.book)}
    }
    
    //Paso 236
    func newQuestion(){
        
        if filteredQuestions.isEmpty{
            return
        }
        //Paso 239
        if answeredQuestions.count == filteredQuestions.count{
            //Empieza de nuevo
            answeredQuestions = []
        }
        //Paso 237
        var potentialQuestion = filteredQuestions.randomElement()!
        while answeredQuestions.contains(potentialQuestion.id){
            potentialQuestion = filteredQuestions.randomElement()!
        }
        //Paso 238
        currentQuestion = potentialQuestion
        
        //V-110,paso 240
        answers = []
        
        //Paso 241,los diccionarios tiene un valor y una llave
        for answer in currentQuestion.answers.keys {
            answers.append(answer)
        }
        //Paso 242,Para ver respuestas aleatorias
        answers.shuffle()
        
        //Paso 247
        questionScore = 5
    }
    
    //Paso 243
    func correct(){
        answeredQuestions.append(currentQuestion.id)
        
        //TODO: Update Score
        //V-113,Paso 270 ponemos animacion
        withAnimation{
            //Paso 248
            gameScore += questionScore
        }
       
    }
    
    //Paso 249
    func endGame (){
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores[0]
        recentScores[0] = gameScore
        
        //Paso 277
        saveScores()
    }
    
    //Paso 278
    func loadScores(){
        do{
            let data = try Data (contentsOf: savePath)
            recentScores = try JSONDecoder().decode([Int].self, from: data)
            
        }catch{
            recentScores = [0,0,0]
        }
    }
    /*
     
     33,27,15
     50(hacemos 50 puntos ,solo se recorre)
     50 27 15
     */
    
    //Paso 232
    private func decodeQuestions(){
        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json"){
            do{
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                allQuestions = try decoder.decode([Question].self, from: data)
                filteredQuestions = allQuestions
           }catch{
                print("Error decoding JSON data: \(error)")
            }
            
        }
    }
    
    //V-114,paso 275
    private func saveScores(){
        do{
            let data = try JSONEncoder().encode(recentScores)
            try data.write(to: savePath)
            
        }catch{
            print("Unable to save data: \(error)")
        }
    }
    
}
