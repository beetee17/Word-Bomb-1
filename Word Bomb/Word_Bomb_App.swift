//
//  Word_Bomb_App.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import SwiftUI

let CountryGame = GameMode(modeName:"COUNTRY", dataFile: "countries", queryFile: nil, instruction: "NAME A COUNTRY", gameType: GameType.Exact, id: 1)

let WordGame = GameMode(modeName: "WORDS", dataFile: "words", queryFile: "syllables", instruction: nil, gameType: GameType.Contains, id: 2)

@main
struct Word_BombApp: App {
    // viewModel should start with no associated gameModel
    // no data to be loaded from file yet (until mode select)
    // however an array of [WordGame] should be loaded (for display of modes)
    // implement GameData struct, it includes String vars for words txt filename, query txt filename, user instruction (if any)
    
    
    let game = WordBombGameViewModel(wordGames: [CountryGame, WordGame])

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(game)
        }
    }
}

