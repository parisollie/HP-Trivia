//
//  Question.swift
//  HP Trivia
//
//  Created by Paul F on 25/10/24.
//

import Foundation

//Vid 108, Paso 222
struct Question: Codable {
    //Sus propiedades
    let id: Int
    let question: String
    //Sera un diccionario
    var answers: [String:Bool] = [:]
    let book:Int
    let hint:String
    
    enum QuestionKeys: String, CodingKey {
        case id
        case question
        case answer
        case wrong
        case book
        case hint
    }
    
    //Paso 223 , ponemos el init
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: QuestionKeys.self)
        //Inicializamos
        id = try container.decode(Int.self, forKey: .id)
        question = try container.decode(String.self, forKey: .question)
        book = try container.decode(Int.self, forKey: .book)
        hint = try container.decode(String.self, forKey: .hint)
        
        let correctAnswer = try container.decode(String.self, forKey: .answer)
        
        //Para el diccionario
        answers[correctAnswer] = true
        //Wrong answer es coleccion de strings
        let wrongAnswers = try container.decode([String].self, forKey: .wrong)
        
        
        for answer in wrongAnswers {
            answers[answer] = false
        }
        
        /*
         Con este se ve mas claro el for
         
         answers:
         {
             "The Boy Who Lived": true,
             "The Kid Who Survived": false,
             "The Baby Who Beat The Dark Lord": false,
             "The Scrawny Teenager": false
         }
         */
        
        
    }
}
