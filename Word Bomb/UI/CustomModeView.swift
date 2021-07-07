//
//  CustomModeView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 7/7/21.
//

import SwiftUI

struct CustomModeView: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        VStack(spacing: 50) {
            Button("Create New") {
                print("Create New Mode")
    //            withAnimation { viewModel.changeViewToShow(.main) }
            }
            
            Button("BACK") {
                print("BACK")
                withAnimation { viewModel.changeViewToShow(.modeSelect) }
            }
            
        }
        .buttonStyle(MainButtonStyle())
    }
}

struct CustomModeView_Previews: PreviewProvider {
    static var previews: some View {
        CustomModeView()
    }
}
