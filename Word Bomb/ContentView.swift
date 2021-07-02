//
//  ContentView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import SwiftUI

#if canImport(UIKit)
// To force SwiftUI to hide keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct ContentView: View {
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        
        switch viewModel.gameMode {
        
            case .none:
                modeSelectView(viewModel: viewModel)
                
            case .some:
            switch viewModel.isPaused {
                
                case true:
                    PauseMenuView(viewModel: viewModel)
                    
                case false:
                GeometryReader { _ in
                    
                    ZStack {
                        
                        TopBarView(viewModel: viewModel)

                        VStack(spacing:100) {
                            
                            PlayerView(viewModel: viewModel)

                            InputView(viewModel: viewModel)
                        
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Views

struct PlayerView: View {
    // Appears in game scene to display current player's name
    
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        
        if viewModel.isGameOver {
         
            Text("\(viewModel.currentPlayer) Loses!")
                .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
        }
        else {
            Text("\(viewModel.currentPlayer)'s Turn!")
                .font(.largeTitle)
        }
    }
}


struct InputView: View {
    // Presented when game is ongoing for user to see query and input an answer
    
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
            
            let output = viewModel.output
            let outputText = Text(output)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .transition(AnyTransition.scale.animation(.easeInOut(duration:0.3)))
                .id(output)
            
            switch output {
                case "CORRECT":
                     outputText.foregroundColor(.green)
                default:
                    outputText.foregroundColor(.red)
                }
            
        }
        .padding(.bottom, 200)
    }
}


struct modeSelectView: View {
    // Presented when starting the game or when user quits a current game
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        ZStack {
            Text("Select Mode")
                .fontWeight(.bold)
                .font(.largeTitle)
                .frame(width:UIScreen.main.bounds.width,
                       height:UIScreen.main.bounds.height*0.8, alignment:.top)
                
            VStack(spacing: 100) {
                modeSelectButton(mode:"COUNTRIES", viewModel: viewModel)
                modeSelectButton(mode:"WORDS", viewModel: viewModel)
            }
        }
        .transition(.slide)
    }
}


struct PauseMenuView: View {
    // Preented when game is paused
    
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        
        VStack(spacing: 100) {
            // RESUME, RESTART, QUIT buttons
            
            Button("RESUME")  {
                print("RESUME!")
                withAnimation { viewModel.togglePauseGame() }
            }
            .buttonStyle(MainButtonStyle())
            
            Button("Restart") {
                print("Restart Game")
                viewModel.restartGame()
            }
            .buttonStyle(MainButtonStyle())
            
 
            Button("QUIT") {
                print("QUIT!")
                withAnimation { viewModel.selectMode(nil) }
            }
            .buttonStyle(MainButtonStyle())
            
        }
        .transition(.scale)
    }
}


struct TopBarView: View {
    // Appears in game screen for user to access pause menu, restart a game
    // and see current time left
    
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        

        ZStack {
            
            TimerView(viewModel: viewModel)
            
            Button("Pause") {
                print("Pause Game")
                hideKeyboard()
                withAnimation(.spring(response:0.1, dampingFraction:0.6)) { viewModel.togglePauseGame() }
            }
            .padding(.trailing, UIScreen.main.bounds.width*0.7)
            
            if viewModel.isGameOver {
                Button("Restart") {
                    print("Restart Game")
                    viewModel.restartGame()
                }.padding(.leading, UIScreen.main.bounds.width*0.7)
            }
            
        }
        .frame(width:UIScreen.main.bounds.width,
               height:UIScreen.main.bounds.height*0.8, alignment:.top)
        
    }
}



// MARK: - Buttons/Single Objects

struct TimerView: View {
    
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        
        let time = String(format: "%.1f", viewModel.timeLeft)
        
        Text(time)
            .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
    }
}

struct modeSelectButton: View {
    
    var mode: String
    @ObservedObject var viewModel: CountryWordBombGame
    
    var body: some View {
        
        Button("\(mode)") {
            // set game mode and proceed to start game
            withAnimation { viewModel.selectMode(mode) }
            print("\(mode) mode!")
        }
        .buttonStyle(MainButtonStyle())
    }
}





// MARK: - Styles
struct MainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.title.bold())
            .frame(width:UIScreen.main.bounds.width/2,
                   height:UIScreen.main.bounds.height*0.05)
            .foregroundColor(Color.black)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 5))
    }
}

// MARK: - Previewer
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
    let game = CountryWordBombGame()
    
    Group {
           ContentView(viewModel:  game).colorScheme(.light)
//               ContentView(viewModel: game).colorScheme(.dark)
       }
    }
}


