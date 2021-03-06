//
//  GameView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI
import CoreData

struct GameView: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel

    var body: some View {
        
        switch viewModel.viewToShow {
        
            case .main: MainView()
            case .modeSelect: ModeSelectView()
            case .pauseMenu: PauseMenuView()
            case .multipeer: LocalMultiplayerView()
            case .customMode: CustomModeView()
            case .peersView: LocalPeersView()
                
            default: // game or gameOver 
                ZStack{
                    Color.clear
                    TopBarView()

                    InputView()
                    PlayerView()
                    OutputText()
                    // for debugging
                    Button("disconnect") {
                        Multipeer.transceiver.stop()
                    }

                }
                .ignoresSafeArea(.all)
            }
        
        }
    
    }


struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView()
    }
}
