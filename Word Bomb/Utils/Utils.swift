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
    case main, modeSelect, customMode, game, gameOver, pauseMenu, multipeer
}


// MARK: - Loading of Data

func getWordSets(_ rawData:[String]) -> (words:[String], wordSets:[String: [String]])  {
    
    var wordSets: [String: [String]] = [:]
    var words: [String] = []
    
    for wordSet in rawData {
        // if more than one variation of the answer => wordSet will be comma separated String
        let variations:[String] = wordSet.components(separatedBy: ", ")
        if variations.count > 1 {
            for i in variations.indices {
                words.append(variations[i])
                wordSets[variations[i]] = []
                for j in variations.indices {
                    if i != j {
                        // iterate through all of the other variations
                        wordSets[variations[i]]?.append(variations[j])
                    }
                }
            }
        } else { words.append(variations[0]) }
    }
    return (words, wordSets)
}

func loadData(_ mode: GameMode) -> (data: [String: [String]], wordSets: [String: [String]])    {
    
    var data: [String: [String]] = [:]
    var wordSets: [String: [String]] = [:]
    
    do {
        let path = Bundle.main.path(forResource: "\(mode.dataFile)", ofType: "txt", inDirectory: "Data")
        print(path ?? "no path found")
        let string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        let Data = getWordSets(string.components(separatedBy: "\n"))
        
        data["data"] = Data.words.sorted()
        wordSets = Data.wordSets
    }
    
    catch let error {
        Swift.print("Fatal Error: \(error.localizedDescription)")
    }
    
    if let queryFile = mode.queryFile {
        
        do {
            let path = Bundle.main.path(forResource: queryFile, ofType: "txt", inDirectory: "Data")
            let string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)

            data["queries"] = string.components(separatedBy: "\n")
            data["queries"]?.removeLast()
        }
        
        catch let error {
            Swift.print("Fatal Error: \(error.localizedDescription)")
        }
    }
    
    return (data, wordSets)
}
