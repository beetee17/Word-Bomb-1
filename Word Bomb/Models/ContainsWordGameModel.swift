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
    var usedWords = Set<Int>()
    
    mutating func process(_ input: String, _ query: String? = "") -> Answer {
        let searchResult = data.search(element: input)
        var answer = Answer.isCorrect
        
        if usedWords.contains(searchResult) {
            print("\(input.uppercased()) ALREADY USED")
            answer = .isAlreadyUsed
           
        }
        else if (searchResult != -1) && input.contains(query!) {
            print("\(input.uppercased()) IS CORRECT")
            usedWords.insert(searchResult)
 
        }
                
        else {
            print("\(input.uppercased()) IS WRONG")
            answer = .isWrong
        }
        
        
        return answer
    }
    
    mutating func resetUsedWords() {
        usedWords = Set<Int>()
    }
    
    mutating func getRandQuery() -> String{
        return queries.randomElement()!

    }

}

