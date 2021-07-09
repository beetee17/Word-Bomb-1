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
    @State var commitInput = false
    
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
            PermanentKeyboard(text: $viewModel.input)
            Text(viewModel.input).onChange(of: viewModel.input, perform: { _ in if viewModel.input.last == "\n" {
                viewModel.processInput()
                viewModel.resetInput()
            }})
            .frame(width: UIScreen.main.bounds.width-40, height: 30, alignment: .center)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 0.75))
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
