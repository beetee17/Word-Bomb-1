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
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        ZStack {
            MPCText().environmentObject(viewModel)
            
            GameView().environmentObject(viewModel)
            
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {

    
    Group {
           ContentView().colorScheme(.light)
//               ContentView(viewModel: game).colorScheme(.dark)
       }
    }
}


