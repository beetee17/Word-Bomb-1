//
//  ContainsWordGameModel.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation

struct ContainsWordGameModel: WordGameModel {
    var data: [String]
    var queries: [String]
    var query: String?
    var instruction: String?
    var usedWords = Set<Int>()
    var output = ""
    
    mutating func process(_ input: String) -> Answer {
        let searchResult = data.search(element: input)
        var answer = Answer.isCorrect
        
        if usedWords.contains(searchResult) {
            output = "\(input.uppercased()) ALREADY USED"
            answer = .isAlreadyUsed
        }
        else if (searchResult != -1) && input.contains(query!) {
            output = "\(input.uppercased()) IS CORRECT"
            usedWords.insert(searchResult)
 
        }
                
        else {
            output = "\(input.uppercased()) IS WRONG"
            answer = .isWrong
        }
        
        getRandQuery()
        return answer
    }
    
    mutating func getRandQuery() {
        query = queries.randomElement()
    }

}

