//
//  ContentView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        
        switch viewModel.gameMode {
        case .none:  modeSelectView(viewModel: viewModel)
        case .some:
            
            ZStack {

                TopBarView()

                VStack(spacing:100) {

                    PlayerView(viewModel: viewModel)

                    InputView(viewModel: viewModel)
                
                }

            }

        }
    }
}

struct PlayerView: View {
    
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        let text = "\(viewModel.currentPlayer)'s Turn!"
        Text(text)
            .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
        
    }
    
    
    
}
struct InputView: View {
    
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        
        VStack {
            
            Text("\(viewModel.query.uppercased())")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            TextField("", text: $viewModel.input, onEditingChanged: { (changed) in
                print("Editing Input - \(changed)")
            }) {
                print("User Committed Input")
                viewModel.processInput()
                
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 20)
            
        }
        .padding(.bottom, 200)
    }
}




struct TopBarView: View {
    
    var body: some View {
        

        HStack(alignment: .center, spacing:100) {
            
            Button("Pause") {
                print("Pause Game")
            }

            Text("10.0")
            
            Button("Restart") {
                print("Restart Game")
            }

            
        }
        .frame(width:UIScreen.main.bounds.width,
               height:UIScreen.main.bounds.height*0.8, alignment:.top)


        

    }
}

struct modeSelectButton: View {
    
    var mode: String
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        
        Button(action: {
            viewModel.selectMode(mode)
            print("\(mode) mode!")
            //set game mode and proceed to start game
            
        }) {
            Text("\(mode)")
                .fontWeight(.bold)
                .font(.title)
                .frame(width:UIScreen.main.bounds.width/2,
                       height:UIScreen.main.bounds.height*0.05)
                .foregroundColor(.black)
                .padding()
                .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 5)
                        )
        }
        
    }
}
struct modeSelectView: View {
    
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        ZStack {
            Text("Select Mode")
                .fontWeight(.bold)
                .font(.largeTitle)
                .frame(width:UIScreen.main.bounds.width,
                       height:UIScreen.main.bounds.height*0.8, alignment:.top)
                
            VStack(spacing:100) {
                modeSelectButton(mode:"COUNTRIES", viewModel: viewModel)
                modeSelectButton(mode:"WORDS", viewModel: viewModel)
            }
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let game = CountryWordBombGame()
//        ContentView(viewModel: game)
        ZStack {

            TopBarView()

            VStack(spacing:100) {
                
                PlayerView(viewModel: game)

                InputView(viewModel: game)
            
            }

        }
    }
}
