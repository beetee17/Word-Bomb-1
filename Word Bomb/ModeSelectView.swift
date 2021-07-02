//
//  ModeSelectView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI


struct ModeSelectView: View {
    // Presented when starting the game or when user quits a current game
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        VStack {

            Text("Select Mode")
                .fontWeight(.bold)
                .font(.largeTitle)
                .padding(.bottom, 100)

                
            VStack(spacing: 100) {
                ModeSelectButton(mode:"COUNTRIES", viewModel: viewModel)
                ModeSelectButton(mode:"WORDS", viewModel: viewModel)
            }
        }
        .transition(.asymmetric(insertion: AnyTransition.move(edge: .trailing), removal: AnyTransition.move(edge: .leading)))
    }
}



struct ModeSelectButton: View {
    
    var mode: String
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        
        Button("\(mode)") {
            // set game mode and proceed to start game
            withAnimation { viewModel.selectMode(mode) }
            print("\(mode) mode!")
        }
        .buttonStyle(MainButtonStyle())
    }
}


struct ModeSelectView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = CountryWordBombGame()
        ModeSelectView(viewModel: game)
    }
}
