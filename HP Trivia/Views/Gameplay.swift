//
//  Gameplay.swift
//  HP Trivia
//
//  Created by Paul F on 23/10/24.
//

import SwiftUI
import AVKit

//V-97,Paso 88, creamos el archivo
struct Gameplay: View {
    //V-98,Paso 110 animaciones
    @State private  var animateViewsIn = false
    //Paso 128,respuesta correcta
    @State private var tappedCorrectAnswer = false
    //Paso 140
    @State private var hintWiggle = false
    //Paso 146
    @State private var scaleNextButton = false
    //Paso 149
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
        //Paso 89 creamos el Geometry Reader
        GeometryReader{geo in
            //Paso 91, ponemos el Zstack
            ZStack{
                //Paso 93, ponemos el background.
                Image("hogwarts")
                    .resizable()
                    .frame(width: geo.size.width * 3 ,height: geo.size.height * 1.05)
                    .overlay(Rectangle().foregroundColor(
                        .black.opacity(0.8)))
                //Paso 94, ponemos el Vstack
                VStack{
                    //Paso 95, ponemos el HStack
                    HStack{
                        //V-98,Paso 125, pone las Mark
                        //MARK: Controls
                        //Paso 96, ponemos el boton
                        Button("End Game") {
                            //TODO: End Game
                            //Vid 127
                            game.endGame()
                            //Vid 115
                            dismiss()
                        }
                        //Paso 95, ponemos sus modifiers
                        .buttonStyle(.borderedProminent)
                        .tint(.red.opacity(0.5))
                        
                        Spacer()
                        
                        //Paso 96
                        Text("Score: \(game.gameScore)")
                    }
                    //Paso 98, agregamos el padding
                    .padding()
                    .padding(.vertical,30)
                    
                    //Vid 112
                    //MARK: Question
                    //Paso 112
                    VStack{
                        //Paso 111
                        if animateViewsIn{
                            //Text("Who is Harry Potter?")
                            //Paso 99, agregamos el texto de las preguntas
                            Text(game.currentQuestion.question)
                                //Agregamos los modifiers
                                .font(.custom(Constants.hpFont, size: 50))
                                .multilineTextAlignment(.center)
                                .padding()
                                //Paso 113
                                .transition(.scale)
                                //Vid 117
                                .opacity(tappedCorrectAnswer ? 0.1 : 1)
                        }
                    }
                    //Paso 114 y 118
                    .animation(.easeInOut(duration:animateViewsIn ? 2 : 0),
                               value: animateViewsIn)
                
                    
                    Spacer()
                    
                    // MARK: Hints
                    HStack{
                        //Paso 117,para animacion
                        VStack{
                            //paso 118
                            if animateViewsIn{
                                //Paso 100, agregamos las imagenes de los libros
                                Image(systemName: "questionmark.app.fill")
                                    //Ponemos sus modifiers
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundColor(.cyan)
                                    //Paso 142, si es verdad  la rotacion sera de esta manera(aunque no funciona)
                                    .rotationEffect(.degrees(hintWiggle ? -13 : -17))
                                    .padding()
                                    .padding(.leading,20)
                                    //Paso 116,ponemos el transition
                                    .transition(.offset(x:-geo.size.width/2))
                                    //Paso 141,ponemos el OnAppear
                                    .onAppear{
                                        //Paso 119, me equivoque en este numero de paso xd
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
                        //Paso 120, ponemos el Vstack con el if ,para animacion
                        VStack{
                            if animateViewsIn{
                                //Paso 101, para el libro
                                Image(systemName: "book.closed")
                                    //Agregamos sus modifiers.
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .foregroundColor(.black)
                                    .frame(width: 100,height: 100)
                                    .background(.cyan)
                                    .cornerRadius(20)
                                     //Paso 144,para que el libro gire en diagonal.
                                    .rotationEffect(.degrees(hintWiggle ? 13 : 17))
                                    .padding()
                                    .padding(.trailing,20)
                                     //Paso 119, ponemos el transiton.
                                    .transition(.offset(x:geo.size.width/2))
                                    //Paso 143
                                    .onAppear{
                                        withAnimation(.easeInOut(duration: 0.1).repeatCount(9).delay(5).repeatForever()){
                                            hintWiggle = true
                                        }
                                    }
                                
                                    //Vid 115, girar el hint
                                    .onTapGesture {
                                        //Paso 121
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
                    //Paso 102, agregamos el LazyVGrid
                    LazyVGrid(columns:[GridItem(),
                        GridItem()]){
                        //Paso 103,ponemos el for
                        ForEach(Array(game.answers.enumerated()),
                        id:\.offset) { i, answer in
                            //Vid 115
                            if game.currentQuestion.answers[answer] == true {
                                //Paso 123, ponemos el Vstack con el if ,para animacion.
                                VStack{
                                    if animateViewsIn{
                                        if tappedCorrectAnswer == false {
                                            //Paso 105, ponemos la respuesta
                                            Text(answer)
                                            //Agregamos sus modifiers.
                                                //Para que pueda entrar toda la respuesta,minimumSca...
                                                .minimumScaleFactor(0.5)
                                                .multilineTextAlignment(.center)
                                                .padding(10)
                                                .frame(width: geo.size.width/2.15,height: 80)
                                                .background(.green.opacity(0.5))
                                                .cornerRadius(25)
                                                //Paso 122, animacion transition
                                                .transition(.asymmetric(insertion: .scale, removal:.scale(scale:5).combined(with: .opacity.animation(.easeOut(duration: 0.5)))))
                                            
                                        
                                                .matchedGeometryEffect(id: "answer", in: namespace)
                                                .onTapGesture {
                                                    //Paso 124
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
                //Paso 95, ponemos el frame.
                .frame(width: geo.size.width,height: geo.size.height)
                //Paso 97, ponemos el color
                .foregroundColor(.white)
                
                //V-99,paso 126
                //MARK: CELEBRATION
                VStack{
                    Spacer()
                    //Paso 131, hacemos el Vstack con el if para la animacion
                    VStack{
                        if tappedCorrectAnswer{
                            //Paso 127, ponemos el puntuaje
                            Text("\(game.questionScore)")
                                //Agregamos sus modifiers
                                .font(.largeTitle)
                                .padding(.top,50)
                                //Paso 130
                                .transition(.offset(y:-geo.size.height/4))
                                //Paso 149, mover el score a la esquina
                                .offset(x:movePointsToScore ?
                                        geo.size.width/2.3 : 0 , y:movePointsToScore ?
                                        -geo.size.height/13 :0)
                                //el cero significa que se hace invisible al pasar a la esquina.
                                .opacity(movePointsToScore ? 0: 1)
                                //Paso 150,ponemos la animacion para que se mueva
                                .onAppear{

                                    withAnimation(
                                        .easeInOut(duration: 1).delay(3)){
                                            movePointsToScore = true
                                        }
                                }
                        }
                    }
                    //Paso 132, ponemos la animacion
                    .animation(.easeInOut(duration: 1).delay(2),
                               value: tappedCorrectAnswer)
                    Spacer()
                    
                    //Paso 134, ponemos el Vstack con el if para animacion
                    VStack{
                        if tappedCorrectAnswer{
                            //Paso 128
                            Text("Brillant")
                                //Agregamos sus modifiers.
                                .font(.custom(Constants.hpFont, size: 100))
                                //Paso 133, ponemos la animacion.
                                .transition(.scale.combined(with: .offset(y:-geo.size.height/2)))
                        }
                    }
                    //Paso 135, ponemos la animacion
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 1 : 0 ).delay(tappedCorrectAnswer ? 1 : 0),
                               value: tappedCorrectAnswer)
                    
                    Spacer()
                    //Vid 114
                    if tappedCorrectAnswer{
                        //Paso 129
                        Text(game.correctAnswer)
                            //Agregamos sus modifiers.
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
                    //Paso 128, agrupar los spacer
                    Group{
                        Spacer()
                        Spacer()
                    }
                    //Paso 137, ponemos el Vstack con el if para animacion
                    VStack{
                        //V-100,paso 139, si machea con la respuesta correcta.
                        if tappedCorrectAnswer{
                            //Paso 130, ponemos el botón.
                            Button("Next Level ->"){
                                //V-99, es lo que se debe hacer.
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
                            //Agreamos sus modifiers.
                            .buttonStyle(.borderedProminent)
                            .tint(.blue.opacity(0.5))
                            .font(.largeTitle)
                            //Paso 136
                            .transition(.offset(y:geo.size.height/3))
                            
                            //Paso 147, si es verdad el boton cambia a 1.2 sino a 1
                            .scaleEffect(scaleNextButton ? 1.2 : 1)
                            //Paso 145
                            .onAppear{
                                withAnimation(.easeInOut(duration: 1.3).repeatForever()){
                                    //Paso 148
                                    scaleNextButton.toggle()
                                }
                            }
                        }
                    }
                    //Paso 138,ponemos la animacion
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 2.7 : 0).delay(tappedCorrectAnswer ? 2.7 :0),
                               value: tappedCorrectAnswer)
                    
                    Group{
                        Spacer()
                        Spacer()
                    }
                }
                .foregroundColor(.white)
            }
            //Paso 92, ponemos el frame para que todo este centrado
            .frame(width: geo.size.width,height: geo.size.height)
        }
        //Paso 90
        .ignoresSafeArea()
        //Paso 115, se debe poner para funcionen las animaciones el OnAppear.
        .onAppear{
            animateViewsIn = true
            //Vid 129
            DispatchQueue.main.asyncAfter(deadline: .now() + 3 ) {
                //V-99,paso 129
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
    VStack{
        Gameplay()
    }
}
