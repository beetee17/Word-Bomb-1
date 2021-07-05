//
//  ExactWordGameModel.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation

struct ExactWordGameModel: WordGameModel {
    var data: [String]
    var query: String?
    var instruction: String?
    var usedWords = Set<Int>()
    var output = ""
    
    mutating func process(_ input: String) -> Answer {
        let searchResult = data.search(element: input)
        
        if usedWords.contains(searchResult) {
            output = "\(input.uppercased()) ALREADY USED"
            return Answer.isAlreadyUsed
        }
        else if (searchResult != -1) {
            output = "\(input.uppercased()) IS CORRECT"
            usedWords.insert(searchResult)
            return Answer.isCorrect
        }
                
        else {
            output = "\(input.uppercased()) IS WRONG"
            return Answer.isWrong
        }
    }
    mutating func getRandQuery() { }
}
