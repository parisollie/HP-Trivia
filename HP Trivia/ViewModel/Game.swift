//
//  Game.swift
//  HP Trivia
//
//  Created by Paul F on 25/10/24.
//

import Foundation
import SwiftUI

@MainActor
class Game : ObservableObject{
    private var allQuestions: [Question] = []
    private var answeredQuestions: [Int] = []
    //Vid 124
    var answer:[String] = []
    //Vid 128
    private let savePath = FileManager.documentsDirectory.appending(path: "SavedScores")
    
    var filteredQuestions: [Question] = []
    var currentQuestion = Constants.previewQuestion
    var answers:  [String] = []
    
    //Para saber la respuesta correcta,queremos la key
    var correctAnswer: String{
        currentQuestion.answers.first(where:{$0.value == true})!.key
    }
    
    //Vid 125
    @Published var gameScore = 0
    @Published var questionScore = 5
    @Published var recentScores = [0,0,0]
    
    init (){
        decodeQuestions()
    }
    //Vid 125
    func startGame(){
        gameScore = 0
        questionScore = 5
        answeredQuestions = []
    }
    //Vid 123
    func filterQuestions(to books: [Int]){
        filteredQuestions = allQuestions.filter{books.contains($0.book)}
    }
    
    func newQuestion(){
        if filteredQuestions.isEmpty{
            return
        }
        if answeredQuestions.count == filteredQuestions.count{
            answeredQuestions = []
        }
        var potentialQuestion = filteredQuestions.randomElement()!
        while answeredQuestions.contains(potentialQuestion.id){
            potentialQuestion = filteredQuestions.randomElement()!
        }
        currentQuestion = potentialQuestion
        
        //Vid 124
        answers = []
        
        //Vid 124
        for answer in currentQuestion.answers.keys {
            answers.append(answer)
        }
        //Para ver respuestas aleatorias
        answers.shuffle()
        
        //Vid 125
        
        questionScore = 5
    }
    
    //Vid 124
    
    func correct(){
        answeredQuestions.append(currentQuestion.id)
        
        //TODO: Update Score
        //Vid 125
        //Vid 127 ponemos animacion
        withAnimation{
            gameScore += questionScore
        }
       
    }
    
    //Vid 125
    func endGame (){
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores[0]
        recentScores[0] = gameScore
        
        //Vid 128
        saveScores()
    }
    
    //Vid 128 
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
    
    //vid 128
    
    private func saveScores(){
        do{
            let data = try JSONEncoder().encode(recentScores)
            try data.write(to: savePath)
            
        }catch{
            print("Unable to save data: \(error)")
        }
    }
    
    
    
    
    
}
