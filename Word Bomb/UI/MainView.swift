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
        ZStack {
            LogoView()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.7, alignment: .top)

            VStack(spacing: 30) {
                Button("Pass & Play") {
                    print("Pass & Play")
                    withAnimation { viewModel.presentModeSelect() }
                }
                    
                Button("Advertise") {
                    print("Advertise")
                    withAnimation { viewModel.advertise() }
                }
               
                
                Button("Invite") {
                    print("Invite")
                    withAnimation { viewModel.invite() }
                }
                    
                
                
         
            }
            .buttonStyle(MainButtonStyle())
            
        }
        .transition(.asymmetric(insertion: AnyTransition.move(edge: .leading), removal: AnyTransition.move(edge: .trailing)))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/) // transition does not work with zIndex set to 0
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let game = WordBombGameViewModel(wordGames: [CountryGame, WordGame])
        MainView(viewModel: game)
    }
}
