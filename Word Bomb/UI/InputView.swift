//
//  InputView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 6/7/21.
//

import SwiftUI


struct InputView: View {
    
    // Presented when game is ongoing for user to see query and input an answer
    
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var instructionText: some View {
        viewModel.instruction.map { Text($0).boldText() }
    }
    var queryText: some View {
        viewModel.query.map { Text($0).boldText() }
    }

    var body: some View {

        VStack {
            
            instructionText
            queryText
            
            TextField("", text: $viewModel.input, onEditingChanged: { (changed) in })
                {
                    print("User Committed Input")
                    viewModel.processInput()
                    viewModel.resetInput()
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            
        }
        .padding(.bottom, 50)
        .ignoresSafeArea(.all)
    }
}


struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
