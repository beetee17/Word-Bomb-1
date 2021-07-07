//
//  GameMode.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation

struct GameMode: Identifiable {
    var modeName: String
    var dataFile: String
    var queryFile: String?
    var instruction: String?
    var gameType: GameType
    var id: Int
    
}

enum GameType {
    case Exact
    case Contains
}

enum Answer  {
    case isCorrect, isWrong, isAlreadyUsed
}

enum ViewToShow: Int, Codable {
    case main, modeSelect, game, gameOver, pauseMenu, multipeer
}
