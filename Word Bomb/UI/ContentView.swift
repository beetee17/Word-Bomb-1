//
//  ContentView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import SwiftUI

#if canImport(UIKit)
// To force SwiftUI to hide keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


struct ContentView: View {
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        ZStack {
            if viewModel.mpcStatus != nil  {
                MPCText(viewModel: viewModel)
            }
            GameView(viewModel: viewModel)
        }
    }
}



struct MPCText: View {
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        VStack {
            
            let mpcStatusText = Text(viewModel.mpcStatus!)
                .font(.caption)

            switch viewModel.mpcStatus!.contains("HOST")  {
                case true: mpcStatusText.foregroundColor(.green)
                case false: mpcStatusText.foregroundColor(.red)
                
            }
            
            Spacer()

        }
        .padding(.top, 40)
        .ignoresSafeArea(.all)
    }
    
}






struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
    let game = WordBombGameViewModel(wordGames: [CountryGame, WordGame])
    
    Group {
           ContentView(viewModel:  game).colorScheme(.light)
//               ContentView(viewModel: game).colorScheme(.dark)
       }
    }
}


