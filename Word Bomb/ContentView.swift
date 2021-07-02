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
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        ZStack {
                    Color.white.ignoresSafeArea(.all)
                    GameView(viewModel: viewModel)
        }
    }
}









struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
    let game = CountryWordBombGame()
    
    Group {
           ContentView(viewModel:  game).colorScheme(.light)
//               ContentView(viewModel: game).colorScheme(.dark)
       }
    }
}


