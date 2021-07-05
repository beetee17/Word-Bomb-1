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
    
    var wordGames: [GameMode]
    
    // multiplayer stuff
    var peerId: MCPeerID
    var session: MCSession
    var nearbyServiceAdvertiser: MCNearbyServiceAdvertiser?
    var serviceType:String = "word-bomb"

    init(wordGames: [GameMode]) {
        self.wordGames = wordGames
        peerId = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        session.delegate = self
       
    }
    func setModel(_ model: WordBombGame) {
        self.model = model
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
            }
            else { words.append(variations[0]) }
        
        }
        return (words, wordSets)
    }
    
    func loadData(_ mode: GameMode) -> (data: [String: [String]], wordSets: [String: [String]])    {
        
        var data: [String: [String]] = [:]
        var wordSets: [String: [String]] = [:]
        
        do {
            let path = Bundle.main.path(forResource: "\(mode.dataFile)", ofType: "txt", inDirectory: "Data")
            print(path)
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
            }
            
            catch let error {
                Swift.print("Fatal Error: \(error.localizedDescription)")
            }
        }
        
        return (data, wordSets)
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
                    let query = gameModel!.getRandQuery()
                    model.setQuery(query)
                }
            } else {
                let query = gameModel!.getRandQuery()
                model.setQuery(query)
            }
            
        }
        model.resetTimer()
        model.selectMode(mode)
        startTimer()
        
    }
    

    func processInput() {
        
        //multiplayer
        if isMultiplayer(self) {
            if peerId.displayName == model.currentPlayer.name && deviceIsHost(self) {
                input = input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                let answer = gameModel!.process(input, model.query)
                model.process(input, answer)
                let query = gameModel!.getRandQuery()
                model.setQuery(query)
                
            }
            
            else if peerId.displayName == model.currentPlayer.name && !deviceIsHost(self) {
                if let inputData = try? JSONEncoder().encode(["input" : input]) {
                    
                    try? session.send(inputData, toPeers: session.connectedPeers, with: .reliable)
                    print("SENT \(input)")
                }
            }
        }
        else {
            
            input = input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            let answer = gameModel!.process(input, model.query)
            model.process(input, answer)
        }
    }
    
    func processPeerInput() {
        input = input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        print("processing \(input)")
        let answer = gameModel!.process(input, model.query)
        if case .isCorrect = answer {
            model.setQuery(gameModel!.getRandQuery())
        }
        model.process(input, answer)
        resetInput()
    }
    
    func presentModeSelect() {
        model.presentModeSelect()
    }
    
    func presentMain() {
        model.selectMode(nil)
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
        gameModel!.resetUsedWords()
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
    
    func sendModel() {
        if let modelData = try? JSONEncoder().encode(model) {
            
            try? session.send(modelData, toPeers: session.connectedPeers, with: .reliable)
            
        }
    }
    func advertise() {
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: serviceType)
        nearbyServiceAdvertiser?.delegate = self
        nearbyServiceAdvertiser?.startAdvertisingPeer()
    }
    
    func invite() {
        let browser = MCBrowserViewController(serviceType: serviceType, session: session)
        browser.delegate = self
        UIApplication.shared.windows.first?.rootViewController?.present(browser, animated: true)
    }
    
    // to allow contentView to read model's value and update
    var currentPlayer: String { model.currentPlayer.name }
        
    var gameMode: String? { model.gameMode }
    
    var gameModes: [GameMode] { self.wordGames }
    
    var modeSelectScreen: Bool { model.modeSelectScreen }
    
    var modeSelected: Bool { (model.gameMode != nil) ? true : false }
    
    var instruction: String? { model.instruction }
    
    var query: String? { model.query }
    
    var timeLeft: Float { model.timeLeft! }
    
    var isGameOver: Bool { model.isGameOver }
    
    var isPaused: Bool { model.isPaused }
    
    var output: String { model.output }
        
}


