//
//  ModeSelectView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI


struct ModeSelectView: View {

    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        ZStack {
            Color.clear
            SelectModeText()
                
            VStack(spacing: 50) {
                ForEach(viewModel.gameModes) { mode in
                    ModeSelectButton(gameMode: mode)
                }

                Button("BACK") {
                    print("BACK")
                    withAnimation { viewModel.changeViewToShow(.main) }
                }
                .buttonStyle(MainButtonStyle())
            }
        }
        .transition(.asymmetric(insertion: AnyTransition.move(edge: .trailing), removal: AnyTransition.move(edge: .leading)))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .environmentObject(viewModel)
    }
}


struct SelectModeText: View {
    
    var body: some View {
        VStack {
            Text("Select Mode")
                .fontWeight(.bold)
                .font(.largeTitle)
            Spacer()
        }
        .padding(.top, 100)
    }
}
struct ModeSelectButton: View {
    
    var gameMode: GameMode
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
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
        ModeSelectView()
    }
}
