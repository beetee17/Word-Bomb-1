//
//  GameView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        
        switch viewModel.modeSelected {
        
            case false:
                switch viewModel.modeSelectScreen {
                    case false:
                        MainView(viewModel: viewModel)
                        
                    case true:
                        ModeSelectView(viewModel: viewModel)
                }
                
            case true:
            switch viewModel.isPaused {
                
                case true:
                    PauseMenuView(viewModel: viewModel)
                    
                case false:
                GeometryReader { _ in
                    
                    ZStack {
                        TopBarView(viewModel: viewModel)
                        
                        VStack(spacing:100) {
                            
                            PlayerView(viewModel: viewModel)

                            InputView(viewModel: viewModel)
                        
                        }
                    }
                }
            }
        }
    }
}



// MARK: - Views

struct PlayerView: View {
    // Appears in game scene to display current player's name
    
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        
        if viewModel.isGameOver {
         
            Text("\(viewModel.currentPlayer) Loses!")
                .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
        }
        else {
            Text("\(viewModel.currentPlayer)'s Turn!")
                .font(.largeTitle)
        }
    }
}



struct InputView: View {
    // Presented when game is ongoing for user to see query and input an answer
    
    @ObservedObject var viewModel: WordBombGameViewModel
    
    
    var body: some View {
        
        
        
        VStack {
            if let instruction = viewModel.instruction {
                Text("\(instruction.uppercased())")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            if let query = viewModel.query {
                Text("\(query.uppercased())")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
            
            TextField("", text: $viewModel.input, onEditingChanged: { (changed) in
                print("Editing Input - \(changed)")
                })
            {
                print("User Committed Input")
                viewModel.processInput()
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 20)
            
            let output = viewModel.output
            let outputText = Text(output)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .transition(AnyTransition.scale.animation(.easeInOut(duration:0.3)))
                .id(output)
            
            switch output.contains("CORRECT") {
                case true: outputText.foregroundColor(.green)
                case false: outputText.foregroundColor(.red)
            }
        }
        .padding(.bottom, 200)
    }
}



struct TopBarView: View {
    // Appears in game screen for user to access pause menu, restart a game
    // and see current time left
    
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        

        ZStack {
            
            TimerView(viewModel: viewModel)
            
            Button("Pause") {
                print("Pause Game")
                hideKeyboard()
                withAnimation(.spring(response:0.1, dampingFraction:0.6)) { viewModel.togglePauseGame() }
            }
            .padding(.trailing, UIScreen.main.bounds.width*0.7)
            
            if viewModel.isGameOver {
                Button("Restart") {
                    print("Restart Game")
                    viewModel.restartGame()
                }.padding(.leading, UIScreen.main.bounds.width*0.7)
            }
            
        }
        .frame(width:UIScreen.main.bounds.width,
               height:UIScreen.main.bounds.height*0.8, alignment:.top)
        
    }
}



// MARK: - Buttons/Single Objects

struct TimerView: View {
    
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        
        let time = String(format: "%.1f", viewModel.timeLeft)
        
        Text(time)
            .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
    }
}




struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = WordBombGameViewModel(wordGames: [CountryGame, WordGame])
        GameView(viewModel: game)
    }
}
