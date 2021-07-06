//
//  MainView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 3/7/21.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        
        switch viewModel.showMultiplayerScreen {
            case true:
                LocalMultiplayerView(viewModel: viewModel)
            case false:
                ZStack {
                    Color.clear
                    
                    LogoView()

                    VStack(spacing: 50) {
                        Button("Pass & Play") {
                            print("Pass & Play")
                            withAnimation { viewModel.presentModeSelect() }
                        }
                            
                        Button("Local Multiplayer") {
                            print("Local Multiplayer")
                            withAnimation { viewModel.showMultiplayerScreen = true }
                        }
                            
                    }
                    .buttonStyle(MainButtonStyle())
                    
                }
                .transition(.asymmetric(insertion: AnyTransition.move(edge: .leading), removal: AnyTransition.move(edge: .trailing)))
                .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
                .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/) // transition does not work with zIndex set to 0
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let game = WordBombGameViewModel(wordGames: [CountryGame, WordGame])
        MainView(viewModel: game)
    }
}
