//
//  MultipeerStatusText.swift
//  Word Bomb
//
//  Created by Brandon Thio on 7/7/21.
//

import SwiftUI
import MultipeerKit

struct MPCText: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @EnvironmentObject var mpcDataSource: MultipeerDataSource
    
    var body: some View {
        VStack {

            let mpcStatusText = Text(viewModel.mpcStatus ?? "")
                    

            if viewModel.mpcStatus != nil {
                switch viewModel.mpcStatus!.lowercased().contains("host")  || viewModel.mpcStatus!.lowercased().contains("to") {
                    case true: mpcStatusText.foregroundColor(.green)
                    case false: mpcStatusText.foregroundColor(.red)

                }
            }
            
    
            
            Spacer()

        }
        .font(.caption)
        .padding(.top, 40)
        .ignoresSafeArea(.all)
        .onChange(of: mpcDataSource.availablePeers,
                  perform: {
                         peer in
                         DispatchQueue.main.async {
                             viewModel.setPlayers()
                             if viewModel.deviceIsHost() {
                                 viewModel.showHostingAlert = true
                                 viewModel.mpcStatus = "You are hosting"
                             }
                             else if viewModel.isMultiplayer() {
                                 viewModel.mpcStatus = "Connnected to \(mpcDataSource.availablePeers[0].name)"
                             }
                             else { viewModel.mpcStatus = "" }
                                                                 }
                                                             })
        .alert(isPresented: $viewModel.showHostingAlert,
               content: { Alert(title: Text("You are the host!"),
                                message: Text("Connected devices can see your game!"),
                                dismissButton: .default(Text("OK"))
                                    {
                                        print("dismissed")
                                        viewModel.showHostingAlert  = false
                                    })
                    })
        .environmentObject(mpcDataSource)
    }
    
}


struct MultipeerStatusText_Previews: PreviewProvider {
    static var previews: some View {
        MPCText()
    }
}
