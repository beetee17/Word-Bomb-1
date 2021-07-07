//
//  OutputText.swift
//  Word Bomb
//
//  Created by Brandon Thio on 6/7/21.
//

import SwiftUI

struct OutputText: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    var body: some View {

        VStack {
            let output = viewModel.output
            let outputText = Text(output)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .textCase(.uppercase)
                .transition(AnyTransition.scale.animation(.easeInOut(duration:0.3)))
                .id(output)
                .onAppear(perform: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1,
                                                          execute: { viewModel.clearOutput(output) })
                })
        
            switch viewModel.output.contains("CORRECT") {
                case true: outputText.foregroundColor(.green)
                case false: outputText.foregroundColor(.red)
            }
        }
        .padding(.top, 60)
    }
}

struct OutputText_Previews: PreviewProvider {
    static var previews: some View {
        OutputText()
    }
}
