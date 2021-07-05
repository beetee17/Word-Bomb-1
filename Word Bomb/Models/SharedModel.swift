//
//  WordBombGame.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import Foundation

struct WordBombGame {
    
    // This model is the mainModel, it implements everything that is independent of the game mode. e.g. it should not implement the processInput function as that differs depending on game mode
    
    var players: [Player] = []
    var currentPlayer: Player
    var gameMode: String?
    
    var timeLimit:Float = 10.0
    var timeLeft: Float?

    var isGameOver:Bool = false
    var isPaused: Bool = false
    
  
    
    init(playerNames: [String]) {

        for index in playerNames.indices {
            players.append(Player(name: playerNames[index], ID: index))
        }
        currentPlayer = players[0]
        
    }
    mutating func process(_ answer: Answer) {
        
        // reset the time for other player iff answer from prev player was correct
        if case .isCorrect = answer {
            nextPlayer()
            resetTimer()
        }

    }
    mutating func resetTimer() { timeLeft = timeLimit }
    
    mutating func nextPlayer() {
        if currentPlayer.ID == players.count-1 {
            currentPlayer = players[0]
        }
        else {
            currentPlayer = players[currentPlayer.ID+1]
        }
        
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


        
}






