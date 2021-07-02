//
//  WordBombGame.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import Foundation

struct WordBombGame {
    
    var players: [Player] = []
    var currentPlayer: Player
    var gameMode: String?
    var modeSelect = false
    
    var data:[String:[String]] = [:]
    var queries:[String:[String]] = [:]
    var query: String = ""
    var usedWords = Set<Int>()
    
    var timeLimit:Float = 10.0
    var timeLeft: Float?

    var isGameOver:Bool = false
    var isPaused: Bool = false
    
    var output: String =  ""
  
    
    init(playerNames: [String]) {

        for index in playerNames.indices {
            players.append(Player(name: playerNames[index], ID: index))
        }
        currentPlayer = players[0]
        
        loadData()
    }
    
    mutating func selectMode(_ mode:String?) {
        
        gameMode = mode
        
        if let mode = gameMode {
            if mode == "countries" {
                query = "NAME A COUNTRY"
            }
            
            else if mode == "words" {
                getRandQuery()
            }
            
            isGameOver = false
        }
        else {
            // User has quit the game
            gameOver()
        }

        timeLeft = timeLimit
    }
    
    mutating func nextPlayer() {
        if currentPlayer.ID == players.count-1 {
            currentPlayer = players[0]
        }
        else {
            currentPlayer = players[currentPlayer.ID+1]
        }
        
        print(currentPlayer.name)
    }
        
    // load datasets
    mutating func loadData() {
    
        do {
            var path = Bundle.main.path(forResource: "countries", ofType: "txt")
            var string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)

            data["countries"] = string.components(separatedBy: "\n")
            
            path = Bundle.main.path(forResource: "words", ofType: "txt")
            string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)

            data["words"] = string.components(separatedBy: "\n")
            
            path = Bundle.main.path(forResource: "syllables", ofType: "txt")
            string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            
            queries["words"] = string.components(separatedBy: "\n")
            
        }
            
        catch let error {
            Swift.print("Fatal Error: \(error.localizedDescription)")
        }
        
    }
    
    
    mutating func process(_ input: String) {
        
        let searchResult = data[gameMode!]!.search(element: input)
        
        if usedWords.contains(searchResult) {
            output = "\(input) ALREADY USED"
        }
        else {
            
            if query != "NAME A COUNTRY" {
                // if game mode involves query (eg must have syllable in word)
                if input.contains(query) && (searchResult != -1) {
                    print("\(input) is CORRECT")
                    isCorrect(searchResult)
   
                }
                else {
                    output = "\(input.capitalized) is WRONG"
                }
            }
                
            else {
                // Check if input is an answer
                if (searchResult != -1) {
                    print("CORRECT")
                    isCorrect(searchResult)
                    
                }
                    
                else {
                    output = "\(input.capitalized) is WRONG"
                }
            }
        }
    }
    
    mutating func isCorrect(_ searchResult: Int) {
        usedWords.insert(searchResult)
        nextPlayer()
        getRandQuery()
        
        // reset the time for other player
        timeLeft = timeLimit
        output = "CORRECT"
    }
    
    mutating func gameOver() {
        isGameOver.toggle()
        isPaused = false
        usedWords = Set<Int>()
        currentPlayer = players[0]
    }

    mutating func getRandQuery() {
        if queries[gameMode!]?.count ?? -1 > 0 {
            query = (queries[gameMode!]?.randomElement()!)!
        }
    }
        
}



// MARK: - Binary Search Extension for Array
extension Array where Element: Comparable {
    
    func search(element: Element) -> Int {
        
        var low = 0
        var high = count - 1
        var mid = Int(high / 2)
        
        while low <= high {
            
            let midElement = self[mid]
            
            if element == midElement {
                return mid
            }
            else if element < midElement {
                high = mid - 1
            }
            else {
                low = mid + 1
            }
            
            mid = (low + high) / 2
        }
        
        return -1
    }
}


