//
//  CountryWordBombGame.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import Foundation
import MultipeerConnectivity

class WordBombGameViewModel: NSObject, ObservableObject {
    
    @Published private var model: WordBombGame = WordBombGame(playerNames: ["BT", "VAL"])
    @Published private var gameModel: WordGameModel?
    
    @Published var input = ""
    @Published var mpcStatus: String?
    
    var wordGames: [GameMode]
    
    // multiplayer stuff
    var peerId: MCPeerID
    var session: MCSession
    var nearbyServiceAdvertiser: MCNearbyServiceAdvertiser?
    var serviceType:String = "word-bomb"

    @Published var advertising = false
    @Published var showHostingAlert = false

    init(wordGames: [GameMode]) {
        self.wordGames = wordGames
        peerId = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        session.delegate = self
       
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
            if isMultiplayer(self) {
                if deviceIsHost(self) {
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
            
            if isMultiplayer(self) {
                if peerId.displayName == model.currentPlayer.name && deviceIsHost(self) {
                    
                    let answer = gameModel!.process(input, model.query)
                    model.process(input, answer)
                    if .isCorrect == answer {
                        model.query = gameModel!.getRandQuery()
                    }
                }
                
                else if peerId.displayName == model.currentPlayer.name && !deviceIsHost(self) {
                    if let inputData = try? JSONEncoder().encode(["input" : input]) {
                        
                        try? session.send(inputData, toPeers: session.connectedPeers, with: .reliable)
                        print("SENT \(input)")
                    }
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
                    if isMultiplayer(self) && deviceIsHost(self) {
                        self.sendModel()
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
    
    func setPlayers(_ peers: [MCPeerID]) {
        var players: [Player] = [Player(name: peerId.displayName, ID: 0)]
        for i in peers.indices {
            let player = Player(name: peers[i].displayName, ID: i+1)
            players.append(player)
            print(player.name)
        }
        
        model.setPlayers(players)
        
    }
    
    func sendModel() {
        if let modelData = try? JSONEncoder().encode(model) {
            
            try? session.send(modelData, toPeers: session.connectedPeers, with: .reliable)
            
        }
    }
    
    func setModel(_ model: WordBombGame) {
        self.model = model
    }
    
    func advertise() {
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: serviceType)
        nearbyServiceAdvertiser?.delegate = self
        nearbyServiceAdvertiser?.startAdvertisingPeer()
        advertising = true
    }
    
    func invite() {
        let browser = MCBrowserViewController(serviceType: serviceType, session: session)
        browser.delegate = self
        UIApplication.shared.windows.first?.rootViewController?.present(browser, animated: true)
    }
    
    func disconnect() {
        session.disconnect()
        mpcStatus = nil
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


