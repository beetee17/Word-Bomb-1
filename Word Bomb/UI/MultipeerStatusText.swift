//
//  MultipeerStatusText.swift
//  Word Bomb
//
//  Created by Brandon Thio on 7/7/21.
//

import SwiftUI

struct MPCText: View {
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        VStack {
            
            if viewModel.advertising && !isMultiplayer(viewModel) { Text("Searching for players...") }
            
            else if viewModel.mpcStatus != nil {
                let mpcStatusText = Text(viewModel.mpcStatus!)

                switch viewModel.mpcStatus!.contains("HOST")  {
                    case true: mpcStatusText.foregroundColor(.green)
                    case false: mpcStatusText.foregroundColor(.red)
                    
                }
            }
            else { Text("") }
            
            Spacer()

        }
        .font(.caption)
        .padding(.top, 40)
        .ignoresSafeArea(.all)
        .alert(isPresented: $viewModel.showHostingAlert,
               content: { Alert(title: Text("You are the host!"),
                                message: Text("Connected devices will see your game!"),
                                dismissButton: .default(Text("OK"))
                                    {
                                        print("dismissed")
                                        viewModel.showHostingAlert  = false
                                    })
                    })
    }
    
}


struct MultipeerStatusText_Previews: PreviewProvider {
    static var previews: some View {
        let game = WordBombGameViewModel(wordGames: [CountryGame, WordGame])
        MPCText(viewModel: game)
    }
}
