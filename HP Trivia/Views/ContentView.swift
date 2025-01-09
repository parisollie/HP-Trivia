//
//  ContentView.swift
//  HP Trivia
//
//  Created by Paul F on 23/10/24.
//

import SwiftUI
//Liberia para el audio.
import AVKit

struct ContentView: View {
    //V-92 ,Paso 15,animations
    @State private var scalePlayButton = false
    //Paso 18, para mover el background
    @State private var moveBackgroundImage = false
    //paso 20, para el audio.
    @State private var audioPlayer: AVAudioPlayer!
    //Paso 24, animation letters
    @State private var animateViewsIn = false
    //V-94,paso 57
    @State private var showInstructions = false
    //V-96,paso 84
    @State private var showSettings = false
    //V-97,paso 106
    @State private var playGame = false
    //v-105,Paso 204
    @EnvironmentObject private var store: Store
    //Vid 123
    @EnvironmentObject private var game: Game
    
    
    
    var body: some View {
        //V-91 ,Paso 1 .empezamos con el GeomtryReader
        GeometryReader{
            geo in
            ZStack{
                //Paso 3,ponemos la imagen de Howarts
                Image("hogwarts")
                    .resizable()
                    .frame(width: geo.size.width * 3 ,height: geo.size.height)
                    .padding(.top,3)
                    //Paso 19,para mover la imagen
                    .offset(x:moveBackgroundImage ? geo.size.width/1.1 :
                                -geo.size.width/1.1)
                    //Modifier para que se mueva la imagen.
                    .onAppear{
                        withAnimation(.linear(duration: 60).repeatForever()){
                            moveBackgroundImage.toggle()
                        }
                    }
                //Paso 4 ,ponemos el Vstack
                VStack{
                    //Paso 26, Vstack para animacion
                    VStack{
                        //Paso 25,para la animacon de las letras
                        if animateViewsIn{
                            //Paso 5, ponemos un Vstack para add la imagen.
                            VStack{
                                Image(systemName: "bolt.fill")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                Text("HP")
                                //Paso 7,usamos nuestra fuente de texto.
                                    .font(.custom(Constants.hpFont, size: 70))
                                    .padding(.bottom,-50)
                                Text("Trivia")
                                    .font(.custom(Constants.hpFont, size: 60))
                            }
                            //Paso 13, agregamos el padding
                            .padding(.top,70)
                            //V-93,Paso 23 movimiento de las letras
                            .transition(.move(edge: .top))
                        }
                        //Paso 27, para poner las letras en animcion.
                    }.animation(.easeOut(duration: 0.7).delay(2),value: animateViewsIn)
                    
                    //Paso 12, Agregamos un Spacer
                    Spacer()
                    
                    //Paso 13, creamos el Vstack
                    VStack{
                        //Paso 45
                        if animateViewsIn{
                            VStack{
                                Text("Recent Scores")
                                    .font(.title2)
                                ///Vid 129
                                Text("\(game.recentScores[0])")
                                Text("\(game.recentScores[1])")
                                Text("\(game.recentScores[2])")
                            }
                            //Paso 14, add los modifiers
                            .font(.title3)
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .background(.black.opacity(0.7))
                            .cornerRadius(15)
                            //Paso 44, para que aparezca en el mismo lugar
                            .transition(.opacity)
                        }
                        //Paso 46
                    }.animation(.linear(duration: 1).delay(4),value: animateViewsIn)
                    
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        //Paso 37
                        VStack{
                            //Paso 36
                            if animateViewsIn{
                                //Paso 8, Creamos el botón.
                                Button{
                                    //Paso 57,vamos a la pantalla de instrucciones
                                    showInstructions.toggle()
                                    
                                }label:{
                                    Image(systemName:"info.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                }
                                //Paso 35
                                .transition(.offset(x:-geo.size.width/4))
                                //Paso 58, llamamos a nuestra vista de instrucciones
                                .sheet(isPresented: $showInstructions){
                                    //Paso 59, vamos a la vista
                                    Instructions()
                                }
                            }
                        }
                        //V-93,Paso 38, se repiten los mismos pasos que en el otro botn
                        .animation(.easeOut(duration: 0.7).delay(2.7),value: animateViewsIn)
                        
                        Spacer()
                        
                        //Paso 32
                        VStack{
                            //Paso 31
                            if animateViewsIn{
                                //Paso 9,Siguiente botón "Play".
                                Button{
                                    filterQuestions()
                                    //Vid 126
                                    game.startGame()
                                    //Vid 111, start new game
                                    playGame.toggle()
                                }label: {
                                    //Paso 14, ponemos en un Text el titulo
                                    Text("Play")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .padding(.vertical,7)
                                        .padding(.horizontal,50)
                                        .background(store.books.contains(.active) ?.brown : .gray)
                                        .cornerRadius(7)
                                        .shadow(radius: 5)
                                    
                                }
                                //Paso 16,si es verdad el botón cambia al valor  1.2 y sino a 1
                                .scaleEffect(scalePlayButton ? 1.2 : 1)
                                //Paso 17,Modifier , tan pronto aparezca el botón haz esto con animacion.
                                .onAppear{
                                    withAnimation(.easeInOut(duration: 1.3).repeatForever()){
                                        scalePlayButton.toggle()
                                    }
                                }
                                //Paso 30
                                .transition(.offset(y:geo.size.height/3))
                                //Vid 111
                                .fullScreenCover(isPresented:$playGame){
                                    Gameplay()
                                    //Vid 123
                                        .environmentObject(game)
                                    //Vid 129
                                        .onAppear{
                                            audioPlayer
                                                .setVolume(0, fadeDuration: 2)
                                        }
                                        .onDisappear{
                                            audioPlayer
                                                .setVolume(1, fadeDuration: 3)
                                        }
                                }
                                //Vid 126
                                .disabled(store.books.contains(.active) ? false : true)
                            }
                            //Paso 34
                        }.animation(.easeOut(duration: 0.7).delay(2),value: animateViewsIn)
                        
                        Spacer()
                        
            
                        //Paso 41
                        VStack{
                            //paso 40
                            if animateViewsIn{
                                //Paso 10, settings boton
                                Button{
                                    //Paso 85,show settings screen
                                    showSettings.toggle()
                                }label:{
                                    Image(systemName: "gearshape.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                }
                                //Paso 39
                                .transition(.offset(x:geo.size.width/4))
                                //Vid 110, llamamos a nuestra vista de instrucciones
                                //paso 86
                                .sheet(isPresented: $showSettings){
                                    //Paso 87
                                    Settings()
                                    //Paso 206
                                    .environmentObject(store)
                                }
                            }
                            //Paso 43
                        }.animation(.easeOut(duration: 0.7).delay(2.7),value: animateViewsIn)
                        
                        
                        Spacer()
                    }
                    //Paso 11,para que quede centrado por la imagen
                    .frame(width: geo.size.width)
                    
                    //Vid 126
                    
                    VStack{
                        if animateViewsIn{
                            if store.books.contains(.active) == false{
                                Text("No questions available. Go to settings.⬆️")
                                    .multilineTextAlignment(.center)
                                    .transition(.opacity)
                            }
                        }
                    }
                    .animation(.easeInOut.delay(3),value:animateViewsIn)
                    
                    Spacer()
                }
            }
            //Paso 2 , ponemos el frame
            .frame(width: geo.size.width,height: geo.size.height)
        }
        .ignoresSafeArea()
        //Paso 22, Tan pronto aparezca la pantalla ponemos el audio, con el onAppear
        .onAppear(){
            //paso 28, llamamos las letras al frente
            animateViewsIn = true
            playAudio()
            
        }
    }
    //--------Es el código del chico ,pero no funciona--------------------------
    
    /*private func playAudio(){
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        //-1 significa infinito
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
    }*/
    
    //---------------------------------------------------------------------------
    
    //Paso 21, Function to initialize and play audio.
    private func playAudio() {
        if let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3") { // Replace "Audio/magic-in-the-air" with "magic-in-the-air" if you have not placed the music files in a separate Audio folder
            do {
                // Try to initialize the audio player
                audioPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
                // Set the number of loops and play the audio
                audioPlayer.numberOfLoops = -1
                audioPlayer.play()
            } catch {
                // This block will execute if any error occurs
                print("There was an issue playing the sound: \(error)")
            }
        } else {
            print("Couldn't find the sound file")
        }
    }
    
    
    
    //Vid 125
    
    private func filterQuestions (){
        var books:[Int] = []
        
        for (index,status) in store.books.enumerated(){
            if status == .active{
                books.append(index + 1)
            }
        }
        
        game.filterQuestions(to: books)
        game.newQuestion()
    }
    
}
    
    

#Preview {
    //Paso 29,
    VStack{
        ContentView()
        //Vid 105
            //.environment(Store())
    }
}
