//
//  PlayerView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 6/7/21.
//

import SwiftUI


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


struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let game = WordBombGameViewModel(wordGames: [CountryGame, WordGame])
        PlayerView(viewModel: game)
    }
}
