//
//  Gameplay.swift
//  HP Trivia
//
//  Created by Paul F on 23/10/24.
//

import SwiftUI
import AVKit

struct Gameplay: View {
    //Vid 112, animaciones
    @State private  var animateViewsIn = false
    //Vid 113
    @State private var tappedCorrectAnswer = false
    //Vid 114
    @State private var hintWiggle = false
    @State private var scaleNextButton = false
    @State private var movePointsToScore = false
    //Vid 115
    @Environment(\.dismiss) var dismiss
    @State private var revealHint = false
    @State private var revealBook = false
    //Vid 116
    @Namespace private var namespace
    //let tempAnswers = [true, false, false,false]
    //Vid 117
    //@State private var tappedWrongAnswer = false
    @State private var wrongAnswersTapped:[Int] = []
    //Vid 118
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    //Vid 123
    @EnvironmentObject private var game: Game
    
    
    var body: some View {
        GeometryReader{geo in
            ZStack{
                Image("hogwarts")
                    .resizable()
                    .frame(width: geo.size.width * 3 ,height: geo.size.height * 1.05)
                    .overlay(Rectangle().foregroundColor(
                        .black.opacity(0.8)))
                VStack{
                    HStack{
                        //MARK: Controls
                        Button("End Game") {
                            //TODO: End Game
                            //Vid 127
                            game.endGame()
                            //Vid 115
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red.opacity(0.5))
                        
                        Spacer()
                        
                        //Text("Score: 33")
                        
                        //Vid 127
                        Text("Score: \(game.gameScore)")
                    }
                    
                    .padding()
                    .padding(.vertical,30)
                    
                    //Vid 112
                    //MARK: Question
                    VStack{
                        if animateViewsIn{
                            //Text("Who is Harry Potter?")
                            //Vid 127
                            Text(game.currentQuestion.question)
                                .font(.custom(Constants.hpFont, size: 50))
                                .multilineTextAlignment(.center)
                                .padding()
                                //Vid 112
                                .transition(.scale)
                                //Vid 117
                                .opacity(tappedCorrectAnswer ? 0.1 : 1)
                        }
                    }
                    //Vid 112 y 118
                    .animation(.easeInOut(duration:animateViewsIn ? 2 : 0),
                               value: animateViewsIn)
                
                    
                    Spacer()
                    
                    // MARK: Hints
                    HStack{
                        //Vid 112
                        VStack{
                            if animateViewsIn{
                                Image(systemName: "questionmark.app.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundColor(.cyan)
                                    .rotationEffect(.degrees(hintWiggle ? -13 : -17))
                                    .padding()
                                    .padding(.leading,20)
                                    .transition(.offset(x:-geo.size.width/2))
                                    .onAppear{
                                        withAnimation(.easeInOut(duration: 0.1).repeatCount(9).delay(5).repeatForever()){
                                            hintWiggle = true
                                        }
                                    }
                                //Vid 115, girar el hint
                                    .onTapGesture {
                                        withAnimation(
                                            .easeInOut(duration: 1)){
                                                revealHint = true
                                            }
                                            //Vid 118
                                        playFliSound()
                                        //Vid 127
                                        game.questionScore -= 1
                                    }
                                    .rotation3DEffect(.degrees(revealHint ? 1440 : 0), axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealHint ? 5 : 1)
                                    .opacity(revealHint ? 0 : 1)
                                    .offset(x: revealHint ? geo.size.width/2 : 0)
                                    .overlay(
                                        //Vid 127
                                        Text(game.currentQuestion.hint)
                                        //Text("The boy Who_____")
                                            .padding(.leading,33)
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.center)
                                            .opacity(revealHint ? 1 : 0)
                                            .scaleEffect(revealHint ? 1.33 : 1)
                                    )
                                    //Vid 117
                                    .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                    .disabled(tappedCorrectAnswer)
                            }
                        }
                        //Vid 112
                        .animation(.easeInOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0),
                                   value: animateViewsIn)
                        
                        Spacer()
                        //Vid 112
                        VStack{
                            if animateViewsIn{
                                Image(systemName: "book.closed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .foregroundColor(.black)
                                    .frame(width: 100,height: 100)
                                    .background(.cyan)
                                    .cornerRadius(20)
                                    .rotationEffect(.degrees(hintWiggle ? 13 : 17))
                                    .padding()
                                    .padding(.trailing,20)
                                    .transition(.offset(x:geo.size.width/2))
                                    .onAppear{
                                        withAnimation(.easeInOut(duration: 0.1).repeatCount(9).delay(5).repeatForever()){
                                            hintWiggle = true
                                        }
                                    }
                                
                                //Vid 115, girar el hint
                                    .onTapGesture {
                                        withAnimation(
                                            .easeInOut(duration: 1)){
                                                revealBook = true
                                            }
                                        //Vid 118
                                        playFliSound()
                                        //Vid 127
                                        game.questionScore -= 1
                                    }
                                    .rotation3DEffect(.degrees(revealBook ? 1440 : 0), axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealBook ? 5 : 1)
                                    .opacity(revealBook ? 0 : 1)
                                    .offset(x: revealBook ? -geo.size.width/2 : 0)
                                    .overlay(
                                        //Vid 127
                                        Image("hp\(game.currentQuestion.book)")
                                        //Image("hp1")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(.trailing,33)
                                            .opacity(revealBook ? 1 : 0)
                                            .scaleEffect(revealBook ? 1.33 : 1)
                                    )
                                    //Vid 117
                                    .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                    .disabled(tappedCorrectAnswer)
                            }
                        }
                        //Vid 112
                        .animation(.easeInOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ?  2 : 0 ),
                                   value: animateViewsIn)
                    }
                    .padding(.bottom)
                    
                    //MARK: ANSWERS
                    LazyVGrid(columns:[GridItem(),
                        GridItem()]){
                        ForEach(Array(game.answers.enumerated()),
                        id:\.offset) { i, answer in
                            //Vid 115
                            if game.currentQuestion.answers[answer] == true {
                                //Vid 112
                                VStack{
                                    if animateViewsIn{
                                        if tappedCorrectAnswer == false {
                                            Text(answer)
                                            //Vid 111, para que pueda entrar toda la respuesta.
                                                .minimumScaleFactor(0.5)
                                                .multilineTextAlignment(.center)
                                                .padding(10)
                                                .frame(width: geo.size.width/2.15,height: 80)
                                                .background(.green.opacity(0.5))
                                                .cornerRadius(25)
                                                //Vid 112
                                                .transition(.asymmetric(insertion: .scale, removal:.scale(scale:5).combined(with: .opacity.animation(.easeOut(duration: 0.5)))))
                                            
                                        
                                                .matchedGeometryEffect(id: "answer", in: namespace)
                                                .onTapGesture {
                                                    withAnimation(.easeOut(duration: 1)){
                                                        tappedCorrectAnswer = true
                                                    }
                                                    //Vid 118
                                                    playCorrectSound()
                                                    //Vid 127
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                                        game.correct()
                                                    }
                                                }
                                        }
                                    }
                                }
                                //Vid 112
                                .animation(.easeInOut(duration:animateViewsIn ? 1 : 0 ).delay(animateViewsIn ?  1.5 : 0),
                                           value: animateViewsIn)
                            }else{
                                
                                //Vid 115
                                VStack{
                                    if animateViewsIn{
                                        Text(answer)
                                        //para que pueda entrar toda la respuesta.
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(
                                                .center)
                                            .padding(10)
                                            .frame(width: geo.size.width/2.15,
                                                   height: 80)
                                            //Vid 116
                                            .background(wrongAnswersTapped.contains(i) ? .red.opacity(0.5) : .green.opacity(0.5))
                                            .cornerRadius(25)
                                            .transition(.scale)
                                             //Vid 116
                                            .onTapGesture{
                                                withAnimation(
                                                    .easeOut(duration:1)){
                                                        wrongAnswersTapped.append(i)
                                                    }
                                                //Vid 118
                                                playWrongSound()
                                                giveWrongFeedback()
                                                //Vid 127
                                                game.questionScore -= 1
                                            }
                                            .scaleEffect(wrongAnswersTapped.contains(i) ? 0.8 : 1 )
                                            // la desabilitamos para que ya no se pueda tocar nueva,ente
                                            .disabled(tappedCorrectAnswer || wrongAnswersTapped.contains(i))
                                            //Vid 117
                                            .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                    }
                                }
                                //Vid 115
                                .animation(.easeInOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0 ),
                                           value: animateViewsIn)
                                
                            }
                        }
                                
                    }
                    
                    Spacer()
                    
                }
                .frame(width: geo.size.width,height: geo.size.height)
                .foregroundColor(.white)
                
                //Vid 113
                //MARK: CELEBRATION
                VStack{
                    Spacer()
                    VStack{
                        if tappedCorrectAnswer{
                            Text("\(game.questionScore)")
                                .font(.largeTitle)
                                .padding(.top,50)
                                .transition(.offset(y:-geo.size.height/4))
                            //Vid 114, mover el score a la esquina
                                .offset(x:movePointsToScore ?
                                        geo.size.width/2.3 : 0 , y:movePointsToScore ?
                                        -geo.size.height/13 :0)
                            //el cero significa que se hace invisible
                                .opacity(movePointsToScore ? 0: 1)
                                .onAppear{
                                    withAnimation(
                                        .easeInOut(duration: 1).delay(3)){
                                            movePointsToScore = true
                                        }
                                }
                        }
                    }
                    //Vid 113
                    .animation(.easeInOut(duration: 1).delay(2),
                               value: tappedCorrectAnswer)
                    Spacer()
                    
                    VStack{
                        if tappedCorrectAnswer{
                            Text("Brillant")
                                .font(.custom(Constants.hpFont, size: 100))
                                .transition(.scale.combined(with: .offset(y:-geo.size.height/2)))
                        }
                    }
                    //Vid 113
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 1 : 0 ).delay(tappedCorrectAnswer ? 1 : 0),
                               value: tappedCorrectAnswer)
                    
                    Spacer()
                    //Vid 114
                    if tappedCorrectAnswer{
                        Text(game.correctAnswer)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: geo.size.width/2.15,height: 80)
                            .background(.green.opacity(0.5))
                            .cornerRadius(25)
                            .scaleEffect(2)
                            //Vid 115
                            .matchedGeometryEffect(id: "answer", in: namespace)
                    }
                    
                    Group{
                        Spacer()
                        Spacer()
                    }
                    
                    VStack{
                        if tappedCorrectAnswer{
                            Button("Next Level ->"){
                                //TODO: Reset level for next question
                                //Vid 117
                                animateViewsIn = false
                                tappedCorrectAnswer = false
                                revealHint = false
                                revealBook = false
                                movePointsToScore = false
                                wrongAnswersTapped = []
                                //Vid 127
                                game.newQuestion()
                                
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                    animateViewsIn = true
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue.opacity(0.5))
                            .font(.largeTitle)
                            //Vid 113
                            .transition(.offset(y:geo.size.height/3))
                            
                            //Vid 106, si es verdad el boton cambia a 1.2 sino a 1
                            .scaleEffect(scaleNextButton ? 1.2 : 1)
                            .onAppear{
                                withAnimation(.easeInOut(duration: 1.3).repeatForever()){
                                    scaleNextButton.toggle()
                                }
                            }
                        }
                    }
                    //Vid 113
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 2.7 : 0).delay(tappedCorrectAnswer ? 2.7 :0),
                               value: tappedCorrectAnswer)
                    
                    Group{
                        Spacer()
                        Spacer()
                    }
                }
                .foregroundColor(.white)
            }.frame(width: geo.size.width,height: geo.size.height)
        }
        .ignoresSafeArea()
        //Vid 112
        .onAppear{
            animateViewsIn = true
            //Vid 129
            DispatchQueue.main.asyncAfter(deadline: .now() + 3 ) {
                //Vid 113
                //tappedCorrectAnswer = true
                playMusic()
            }
        }
    }
    //Vid 118
    
    // Function to initialize and play audio.
    private func playMusic() {
        let songs = ["let-the-mystery-unfold","spellcraft","hiding-place-in-the-forest","deep-in-the-dell"]
        let i = Int.random(in: 0...3)
        
        
        if let sound = Bundle.main.path(forResource: songs[i], ofType: "mp3") { // Replace "Audio/magic-in-the-air" with "magic-in-the-air" if you have not placed the music files in a separate Audio folder
            do {
                // Try to initialize the audio player
                musicPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound))
                //Vid 118
                musicPlayer.volume = 0.1
                // Set the number of loops and play the audio
                musicPlayer.numberOfLoops = -1
                musicPlayer.play()
            } catch {
                // This block will execute if any error occurs
                print("There was an issue playing the sound: \(error)")
            }
        } else {
            print("Couldn't find the sound file")
        }
        
        
    }
    
    private func playFliSound() {
        let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }
    
    private func playWrongSound() {
        let sound = Bundle.main.path(forResource: "negative-beeps", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }
    
    private func playCorrectSound() {
        let sound = Bundle.main.path(forResource: "magic-wand", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }
    
    private func giveWrongFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    
    
    
}

#Preview {
    Gameplay()
}
