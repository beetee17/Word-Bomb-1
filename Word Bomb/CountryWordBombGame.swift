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
    
    func selectMode(_ mode:String?) {
        model.selectMode(mode?.lowercased())
        startTimer()
    }
    
    func processInput() {
        model.process(input.lowercased())
        input = ""
    }
    
    func togglePauseGame() {
        
        if model.isPaused {
            // resuming game
            model.isPaused.toggle()
            startTimer()
        }
        else {
            model.isPaused.toggle()
        }
        
    }
    
    func restartGame() {
        model.isGameOver = false
        model.isPaused = false
        model.timeLeft = 10
        startTimer()
    }
    
    func startTimer() {
        print("Timer started")
   
            print("Timer started")
            let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in

                if self.model.timeLeft! <= 0 {
                    timer.invalidate()
                    self.model.gameOver()
                    print("Timer stopped")
                }
                else if self.model.isPaused || self.model.isGameOver {
                    timer.invalidate()
                }
                
                else {
                    
                    DispatchQueue.main.async {
                        self.model.timeLeft! = max(0, self.model.timeLeft! - 0.1)
//                        print(self.model.timeLeft!)
                    }
             
                    
                }
                
            }
        
        }
       
   

    
    var currentPlayer: String { model.currentPlayer.name }
        
    var gameMode: String? { model.gameMode }
    
    var query: String { model.query }
    
    var timeLeft: Float { model.timeLeft! }
    
    var isGameOver: Bool { model.isGameOver }
    
    var isPaused: Bool { model.isPaused }
    
    var output: String { model.output }
        
    }


