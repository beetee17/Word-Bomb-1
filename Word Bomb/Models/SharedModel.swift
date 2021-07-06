//
//  WordBombGame.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import Foundation

struct WordBombGame: Codable {
    
    // This model is the mainModel, it implements everything that is independent of the game mode. e.g. it should not implement the processInput function as that differs depending on game mode
    
    var players: [Player] = []
    var currentPlayer: Player
    var gameMode: String?
    var modeSelectScreen: Bool = false
    
    var timeLimit:Float = 10.0
    var timeLeft: Float?

    var isGameOver:Bool = false
    var isPaused: Bool = false
    
    var output = ""
    var query: String?
    var instruction: String?
    
    init(playerNames: [String]) {

        for index in playerNames.indices {
            players.append(Player(name: playerNames[index], ID: index))
        }
        currentPlayer = players[0]
        
    }
    
    mutating func setPlayers(_ players: [Player]) {
        self.players = players
        currentPlayer = players[0]
    }
    
    mutating func process(_ input: String, _ answer: Answer) {
        
        // reset the time for other player iff answer from prev player was correct
        switch answer {
            case .isCorrect:
                output = "\(input.uppercased()) IS CORRECT"
                nextPlayer()
                resetTimer()
            case .isWrong:
                output = "\(input.uppercased()) IS WRONG"
            case .isAlreadyUsed:
                output = "ALREADY USED \(input.uppercased())"
        }
    }
    
    mutating func setQuery(_ query: String) {
        self.query = query
    }
    
    mutating func resetTimer() { timeLeft = timeLimit }
    mutating func clearOutput() { output =  "" }
    
    mutating func nextPlayer() {
        let nextPlayerID = (currentPlayer.ID + 1) % players.count
        currentPlayer = players[nextPlayerID]
        
        print(currentPlayer.name)
    }
        
    mutating func gameOver() {
        isGameOver.toggle()
        isPaused = false
    }
    
    mutating func restartGame() {
        isGameOver = false
        isPaused = false
        timeLeft = 10
        currentPlayer = players[0]
    }
    
    mutating func selectMode(_ mode: GameMode?) {
        
        if let Mode = mode {
            gameMode = Mode.modeName
            instruction = Mode.instruction
            
        }
        else {
            gameMode = nil
        }
        modeSelectScreen = false
    }
    
    mutating func clearUI() {
        output = ""
        query = ""
        instruction = ""
    }
    
    mutating func presentModeSelect() {
        modeSelectScreen = true
    }


        
}






