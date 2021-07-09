//
//  CountryWordBombGame.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import Foundation
import MultipeerConnectivity
import MultipeerKit

class WordBombGameViewModel: NSObject, ObservableObject {
    
    @Published private var model: WordBombGame = WordBombGame(playerNames: ["BT", "VAL"])
    @Published private var gameModel: WordGameModel?
    
    @Published var input = ""
    @Published var mpcStatus: String?
    
    var wordGames: [GameMode]

    @Published var showHostingAlert = false
    

    init(_ wordGames: [GameMode]) {
        self.wordGames = wordGames
    }
    
    
    func changeViewToShow(_ view: ViewToShow) {
        model.viewToShow = view
    }
    
    func selectCustomMode(_ item: Item) {
        model.clearUI()
        
        let data = decodeJSONStringtoArray(item.data!)
        model.instruction = item.instruction
      
        if item.gameType! == "EXACT" {
            gameModel = (ExactWordGameModel(data: data, dataDict: [:]))
            print(gameModel)
        }
        
        changeViewToShow(.game)
        model.resetTimer()
        startTimer()
        
    }
    func selectMode(_ mode:GameMode) {
        
        model.clearUI()
        let (data, wordSets) = loadData(mode)
        // on modeSelect, the appropriate model should be initialised
        switch mode.gameType {
        case .Exact: gameModel = ExactWordGameModel(data: data["data"]!, dataDict: wordSets)
            
        case .Contains:
            gameModel = ContainsWordGameModel(data: data["data"]!, queries: data["queries"]!)
            if isMultiplayer() {
                if deviceIsHost() {
                    model.query = gameModel!.getRandQuery()
                }
            } else {
                model.query = gameModel!.getRandQuery()
            }
            
        }
        
        changeViewToShow(.game)
        model.instruction = mode.instruction
        
        model.resetTimer()
        startTimer()
        
    }
    

    func processInput() {
        
        input = input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !(input == "" || model.timeLeft! <= 0) {

            if isMultiplayer() {
                if MCPeerID.defaultDisplayName == model.currentPlayer.name && deviceIsHost() {

                    let answer = gameModel!.process(input, model.query)
                    model.process(input, answer)
                    if .isCorrect == answer {
                        model.query = gameModel!.getRandQuery()
                    }
                }

                else if MCPeerID.defaultDisplayName == model.currentPlayer.name && !deviceIsHost() {
                    Multipeer.transceiver.broadcast(input)
                    print("SENT \(input)")
                    
                }
            }
            else {
                
                let answer = gameModel!.process(input, model.query)
                if .isCorrect == answer {
                    model.query = gameModel!.getRandQuery()
                }
                model.process(input, answer)
            }
        }
    }
    
    
    func restartGame() {
        gameModel!.resetUsedWords()
        model.restartGame()
        changeViewToShow(.game)
        startTimer()
    }
    
    func startTimer() {
        print("Timer started")
   
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in

            if .game != self.viewToShow {
                timer.invalidate()
                print("Timer stopped")
            }
            
            else if self.model.timeLeft! <= 0 {
                timer.invalidate()
                self.changeViewToShow(.gameOver)
                print("Timer stopped")
            }
        
            else {
                
                DispatchQueue.main.async {
                    self.model.timeLeft! = max(0, self.model.timeLeft! - 0.1)
                    if self.isMultiplayer() && self.deviceIsHost() {
                        print("sending model")
                        Multipeer.transceiver.broadcast(self.model)
                    }
                }
            }
        }
    }

    func resetInput() {
        input = ""
    }
    
    // check if output is still the same as current to avoid clearing of new outputs 
    func clearOutput(_ output: String) { if output == model.output { model.clearOutput() } }
    
    
    // MARK: - Multipeer Functionality
    func setUpTransceiver() {
        print("Setting up transceiver")
        Multipeer.transceiver.receive(WordBombGame.self) { payload, sender in
            print("Got model from \(sender.name)! \(payload)")
            self.model = payload
        }
        Multipeer.transceiver.receive(String.self) { payload, sender in
            print("Got input from \(sender.name)! \(payload)")
            self.input = payload
            self.processPeerInput()
        }
    }
    
    func processPeerInput() {
        input = input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        print("processing \(input)")
        let answer = gameModel!.process(input, model.query)
        if case .isCorrect = answer {
            model.query = gameModel!.getRandQuery()
        }
        model.process(input, answer)
        resetInput()
    }
    
    func isMultiplayer() -> Bool {
        var connectedPeers: [Peer] = []
        for peer in Multipeer.transceiver.availablePeers {
            if peer.isConnected { connectedPeers.append(peer) }
        }
        print("multiplayer \(connectedPeers.count > 0)")
        return connectedPeers.count > 0
    }

    func deviceIsHost() -> Bool {
        var connectedPeers: [Peer] = []
        for peer in Multipeer.transceiver.availablePeers {
            if peer.isConnected { connectedPeers.append(peer) }
        }
        
        if connectedPeers.count == 0 { return false }
        
        for peer in connectedPeers {
            print(peer.name)
            if peer.name  < MCPeerID.defaultDisplayName {
                print("Not host")
                return false
            }
        }
        print("am host")
        return true
    }
    

    func setPlayers() {
        
        if deviceIsHost() {
            var players: [Player] = [Player(name: MCPeerID.defaultDisplayName, ID: 0)]
            
            for i in Multipeer.transceiver.availablePeers.indices {
                let player = Player(name: Multipeer.transceiver.availablePeers[i].name, ID: i+1)
                players.append(player)
            }
            print("players set \(players)")
            model.setPlayers(players)
        }

    }

    
    
    // to allow contentView to read model's value and update
    var currentPlayer: String { model.currentPlayer.name }
    
    var gameModes: [GameMode] { self.wordGames }
    
    var instruction: String? { model.instruction }
    
    var query: String? { model.query }
    
    var timeLeft: Float { model.timeLeft! }
    
    var viewToShow: ViewToShow { model.viewToShow }
    
    var output: String { model.output }

    
        
}


