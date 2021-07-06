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



// MARK: - Buttons/Single Objects




struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = WordBombGameViewModel(wordGames: [CountryGame, WordGame])
        GameView(viewModel: game)
    }
}
