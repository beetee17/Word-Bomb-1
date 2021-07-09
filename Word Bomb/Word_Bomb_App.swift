//
//  Word_Bomb_App.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import SwiftUI
import MultipeerKit
import MultipeerConnectivity

let CountryGame = GameMode(modeName:"COUNTRY", dataFile: "countries", queryFile: nil, instruction: "NAME A COUNTRY", words: nil, queries: nil, gameType: GameType.Exact, id: 1)

let WordGame = GameMode(modeName: "WORDS", dataFile: "words", queryFile: "syllables", instruction: nil, words: nil, queries: nil, gameType: GameType.Contains, id: 2)

let defaultPlayers = [Player(name: "BT", ID: 0), Player(name: "VAL", ID: 1)]

@main
struct Word_BombApp: App {
    // viewModel should start with no associated gameModel
    // no data to be loaded from file yet (until mode select)
    // however an array of [WordGame] should be loaded (for display of modes)
    // implement GameData struct, it includes String vars for words txt filename, query txt filename, user instruction (if any)
    
    let persistenceController = PersistenceController.shared
    let game = WordBombGameViewModel([CountryGame, WordGame])
    
    
    let mpcDataSource = MultipeerDataSource(transceiver: Multipeer.transceiver)
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environmentObject(game)
                .environmentObject(mpcDataSource)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}

