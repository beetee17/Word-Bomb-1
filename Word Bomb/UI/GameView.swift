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
                    ZStack{
                        Color.clear
                        TopBarView(viewModel:  viewModel)

                        InputView(viewModel: viewModel)
                        PlayerView(viewModel: viewModel)
                        OutputText(viewModel: viewModel)

                    }
                    .ignoresSafeArea(.all)
            }
        }
    }
}



// MARK: - Views

struct PlayerView: View {
    // Appears in game scene to display current player's name
    
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        
        VStack {
            Spacer()
            
            if viewModel.isGameOver {
             
                Text("\(viewModel.currentPlayer) Loses!")
                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
            }
            else {
                Text("\(viewModel.currentPlayer)'s Turn!")
                    .font(.largeTitle)
            }
            Spacer()
        }
        .padding(.bottom, 500)
    }
}



struct InputView: View {
    
    // Presented when game is ongoing for user to see query and input an answer
    
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var instructionText: some View {
        viewModel.instruction.map { Text($0).boldText() }
    }
    var queryText: some View {
        viewModel.query.map { Text($0).boldText() }
    }

    var body: some View {

        VStack {
            
            instructionText
            queryText
            
            TextField("", text: $viewModel.input, onEditingChanged: { (changed) in })
                {
                    print("User Committed Input")
                    viewModel.processInput()
                    viewModel.resetInput()
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            
        }
        .padding(.bottom, 50)
        .ignoresSafeArea(.all)
    }
}

struct TopBarView: View {
    // Appears in game screen for user to access pause menu, restart a game
    // and see current time left
    
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var gameOverButton: some View {
        Button("Restart") {
            print("Restart Game")
            viewModel.restartGame()
        }
    }
    
    var body: some View {

        VStack{
            HStack {
                Button("Pause") {
                    print("Pause Game")
                    hideKeyboard()
                    withAnimation(.spring(response:0.1, dampingFraction:0.6)) { viewModel.togglePauseGame() }
                }
                
                Spacer()
                
                TimerView(viewModel: viewModel)
                
                Spacer()
  
                if viewModel.isGameOver { gameOverButton.opacity(1) }
                else { gameOverButton.opacity(0) }
            }
            Spacer()
        }
        .padding(.top, 50)
        .padding(.horizontal, 20)
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


struct OutputText: View {
    @ObservedObject var viewModel: WordBombGameViewModel
    var body: some View {

        VStack {
            let output = viewModel.output
            let outputText = Text(output)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .transition(AnyTransition.scale.animation(.easeInOut(duration:0.3)))
                .id(output)
                .onAppear(perform: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1,
                                                          execute: { viewModel.clearOutput(output) })
                })
        
            switch viewModel.output.contains("CORRECT") {
                case true: outputText.foregroundColor(.green)
                case false: outputText.foregroundColor(.red)
            }
        }
        .padding(.top, 60)
    }
}



struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = WordBombGameViewModel(wordGames: [CountryGame, WordGame])
        GameView(viewModel: game)
    }
}
