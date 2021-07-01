//
//  Word_BombApp.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import SwiftUI

@main
struct Word_BombApp: App {
    
    let game = CountryWordBombGame()

   
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
