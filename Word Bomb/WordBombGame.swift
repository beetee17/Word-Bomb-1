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
    
    var data:[String:[String]] = [:]
    var queries:[String:[String]] = [:]
    var query: String?
    var usedWords = Set<Int>()
    
    var timeLimit:Double = 10.0
    var input = ""
    
    init(playerNames: [String]) {

        for index in playerNames.indices {
            players.append(Player(name: playerNames[index], ID: index))
        }
        currentPlayer = players[0]
        
        loadData()
    }
    
    mutating func selectMode(_ mode:String) {
        
        gameMode = mode
        
        if mode == "countries" {
            query = "NAME A COUNTRY"
        }
        
        else if mode == "words" {
            getRandQuery()
        }
        
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
            print("WRONG - \(input) ALREADY USED")
        }
        else {
            
            if let q = query as String? {
                // if game mode involves query (eg must have syllable in word)
                if input.contains(q) && (searchResult != -1){
                    print("\(input) is CORRECT")
                    usedWords.insert(searchResult)
                    nextPlayer()
                    getRandQuery()
                }
                else {
                    print("\(input) is WRONG")
                }
            }
                
            else {
                // Check if input is an answer
                if (searchResult != -1) {
                    print("CORRECT")
                    usedWords.insert(searchResult)
                    nextPlayer()
                    getRandQuery()
                }
                    
                else {
                    print("WRONG")
                }
            }
        }
    }
    
    mutating func getRandQuery() {
        if queries[gameMode!]?.count ?? -1 > 0 {
            query = queries[gameMode!]?.randomElement()!
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


