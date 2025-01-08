//
//  Instructions.swift
//  HP Trivia
//
//  Created by Paul F on 23/10/24.
//

import SwiftUI

//Vid 108
struct Instructions: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
            InfoBackgroundImage()
            VStack{
                Image("hermione")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top)
                
                
                    ScrollView{
                        Text("How to play")
                            .font(.largeTitle)
                            .padding()
                        VStack(alignment: .leading){
                            Text("Welcome to HP Trivia! In this game,you will be asked random questions from the HP books and you must guess the right answer or you will lose porints!😱")
                               .padding([.horizontal, .bottom])
                            
                            Text("Each question is worth 5 points, but if you guess a wrong answer,you lose point.")
                                .padding([.horizontal, .bottom])
                            Text("If you are struggling with a question,there is an option to reveal a hint or reveal the book that answers the question.But beware! Using these also minuses 1 point each.")
                                .padding([.horizontal, .bottom])
                            Text("When you select the correct answer, you will be awarded all the points left for that question and they will be added to your total score.")
                                .padding(.horizontal)
                       
                        
                    }
                    .font(.title3)
                    Text("Good luck!🍀")
                        .font(.title)
                }
                .foregroundColor(.black)//para que no afecte al modo oscuro
                .background(.white.opacity(0.7))
                .cornerRadius(15)
                Button("Done"){
                    dismiss()
                }
                .doneButton()
            }
           
            
            
        }
    }
}

#Preview {
    Instructions()
}
