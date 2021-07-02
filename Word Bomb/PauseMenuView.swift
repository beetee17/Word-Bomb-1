//
//  PauseMenuView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI


struct PauseMenuView: View {
    // Preented when game is paused
    
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        
        VStack(spacing: 100) {
            // RESUME, RESTART, QUIT buttons
            
            Button("RESUME")  {
                print("RESUME!")
                withAnimation { viewModel.togglePauseGame() }
            }
            .buttonStyle(MainButtonStyle())
            
            Button("Restart") {
                print("Restart Game")
                viewModel.restartGame()
            }
            .buttonStyle(MainButtonStyle())
            
 
            Button("QUIT") {
                print("QUIT!")
                withAnimation { viewModel.selectMode(nil) }
            }
            .buttonStyle(MainButtonStyle())
            
        }
        .transition(.scale)
    }
}

struct PauseMenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = CountryWordBombGame()
        PauseMenuView(viewModel: game)
    }
}
