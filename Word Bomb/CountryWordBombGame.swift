//
//  CountryWordBombGame.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import Foundation

class CountryWordBombGame: ObservableObject {
    
    @Published private(set) var model: WordBombGame = WordBombGame(playerNames: ["BT", "VAL"])
    @Published var input = ""
    @Published var output = ""
    
    func selectMode(_ mode:String) {
        model.selectMode(mode.lowercased())
    }
    
    func processInput() {
        model.process(input.lowercased())
        input = ""
    }
    
    var currentPlayer: String { model.currentPlayer.name }
        
    var gameMode: String? {model.gameMode}
    
    var query: String {model.query!}
        
    }


