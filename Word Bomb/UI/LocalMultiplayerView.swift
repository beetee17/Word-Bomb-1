//
//  MainView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 3/7/21.
//

import SwiftUI

struct LocalMultiplayerView: View {
    
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        ZStack {
            Color.clear
            
            VStack(spacing: 50) {
                    
                Button("Join Game") {
                    print("Join Game")
                    withAnimation { viewModel.advertise() }
                }
               
                
                Button("Host Game") {
                    print("Host Game")
                    withAnimation { viewModel.invite() }
                }
                Button("Disconnect") {
                    print("Disconnect")
                    withAnimation { viewModel.disconnect() }
                }
                
                Button("Back") {
                    print("Back")
                    withAnimation { viewModel.showMultiplayerScreen = false }
                }
                    
            }
            .buttonStyle(MainButtonStyle())
            
        }
        .transition(.asymmetric(insertion: AnyTransition.move(edge: .trailing), removal: AnyTransition.move(edge: .leading)))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/) // transition does not work with zIndex set to 0
    }
}

struct LocalMultiplayerView_Previews: PreviewProvider {
    static var previews: some View {
        let game = WordBombGameViewModel(wordGames: [CountryGame, WordGame])
        LocalMultiplayerView(viewModel: game)
    }
}
