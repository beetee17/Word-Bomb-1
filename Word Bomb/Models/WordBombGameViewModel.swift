//
//  CountryWordBombGame.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import Foundation

class WordBombGameViewModel: ObservableObject {
    
    @Published private var model: WordBombGame = WordBombGame(playerNames: ["BT", "VAL"])
    @Published private var gameModel: WordGameModel?
    
    @Published var input = ""
    @Published var modeSelectScreen: Bool = false
    
    var wordGames: [GameMode]

    init(wordGames: [GameMode]) {
        self.wordGames = wordGames
       
    }
    
    // implement protocol WordGameModel and various structs conforming to the protocol (mainly to implement processInput function for ExactMatches and ContainsQuery)
//    @Published private var gameModel: some WordGameModel?
    func loadData(_ mode: GameMode) -> Dictionary<String, [String]>  {
        
        var data = Dictionary<String, [String]>()
        do {
            let path = Bundle.main.path(forResource: "\(mode.dataFile)", ofType: "txt", inDirectory: "Data")
            print(path)
            let string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)

            data["data"] = string.components(separatedBy: "\n")
        }
        
        catch let error {
            Swift.print("Fatal Error: \(error.localizedDescription)")
        }
        
        if let queryFile = mode.queryFile {
            
            do {
                let path = Bundle.main.path(forResource: queryFile, ofType: "txt", inDirectory: "Data")
                let string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)

                data["queries"] = string.components(separatedBy: "\n")
            }
            
            catch let error {
                Swift.print("Fatal Error: \(error.localizedDescription)")
            }
        }
        
        return data
    }
    
    func selectMode(_ mode:GameMode) {
        
        let data = loadData(mode)
        // on modeSelect, the appropriate model should be initialised
        switch mode.gameType {
        case .Exact: gameModel = ExactWordGameModel(data: data["data"]!, instruction: mode.instruction)
            
        case .Contains:
            gameModel = ContainsWordGameModel(data: data["data"]!, queries: data["queries"]!, instruction: mode.instruction)
            gameModel!.getRandQuery()
        }
        model.resetTimer()
        modeSelectScreen = false
        startTimer()
    }
    
    func processInput() {
        let answer = gameModel!.process(input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
        model.process(answer)
        input = ""
    
    }
    
    func presentModeSelect() {
        modeSelectScreen = true
        print(modeSelectScreen)
    }
    
    func presentMain() {
        modeSelectScreen = false
        model.isPaused = false
        gameModel = nil
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
        model.restartGame()
        startTimer()
    }
    
    func startTimer() {
        print("Timer started")
   
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in

            if self.model.isPaused || self.model.isGameOver {
                timer.invalidate()
                print("Timer stopped")
            }
            
            else if self.model.timeLeft! <= 0 {
                timer.invalidate()
                self.model.gameOver()
                print("Timer stopped")
            }
            
            
            else {
                
                DispatchQueue.main.async {
                    self.model.timeLeft! = max(0, self.model.timeLeft! - 0.1)
                }
            }
        }
    }
    
    // to allow contentView to read model's value and update
    var currentPlayer: String { model.currentPlayer.name }
        
    var gameMode: String? { model.gameMode }
    
    var gameModes: [GameMode] { self.wordGames }
    
    var modeSelected: Bool { (gameModel != nil) ? true : false }
    
    var instruction: String? { gameModel?.instruction }
    
    var query: String? { gameModel?.query }
    
    var timeLeft: Float { model.timeLeft! }
    
    var isGameOver: Bool { model.isGameOver }
    
    var isPaused: Bool { model.isPaused }
    
    var output: String { gameModel!.output }
        
}


