//
//  ModeSelectView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI


struct ModeSelectView: View {
    // Presented when starting the game or when user quits a current game
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        VStack {

            Text("Select Mode")
                .fontWeight(.bold)
                .font(.largeTitle)
                .padding(.bottom, 100)

                
            VStack(spacing: 100) {
                
                ForEach(viewModel.gameModes) { mode in
                    ModeSelectButton(gameMode: mode, viewModel: viewModel)
                }

                Button("BACK") {
                    print("BACK")
                    withAnimation { viewModel.presentMain() }
                }
                .buttonStyle(MainButtonStyle())
                
            }
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .transition(.asymmetric(insertion: AnyTransition.move(edge: .trailing), removal: AnyTransition.move(edge: .leading)))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        
    }
}



struct ModeSelectButton: View {
    
    var gameMode: GameMode
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        
        Button("\(gameMode.modeName)") {
            // set game mode and proceed to start game
            withAnimation { viewModel.selectMode(gameMode) }
            print("\(gameMode.modeName) mode!")
        }
        .buttonStyle(MainButtonStyle())
    }
}


struct ModeSelectView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let game = WordBombGameViewModel(wordGames: [CountryGame, WordGame])
        ModeSelectView(viewModel: game)
    }
}
