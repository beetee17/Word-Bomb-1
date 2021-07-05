//
//  WordGameModel.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation

protocol WordGameModel {
    var data:[String] { get }
    var query: String? { get set }
    var instruction: String? { get }
    var usedWords: Set<Int> { get set }
    var output: String { get set }
    
    mutating func process(_ input: String) -> Answer
    mutating func getRandQuery()
}


