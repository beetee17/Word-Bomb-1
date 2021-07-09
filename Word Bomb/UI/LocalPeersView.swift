//
//  LocalPeersView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 9/7/21.
//

import SwiftUI
import MultipeerKit

struct LocalPeersView: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @EnvironmentObject var mpcDataSource: MultipeerDataSource
    var body: some View {
        VStack {
            
            VStack(alignment: .leading) {
                Text("Peers").font(.system(.headline)).padding()

                List {
                    ForEach(mpcDataSource.availablePeers) { peer in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundColor(peer.isConnected ? .green : .gray)
                            
                            Text(peer.name)

                            Spacer()

                        }
                        .onTapGesture {
                            // connects to the peer
                            DispatchQueue.main.async {
                                Multipeer.transceiver.invite(peer, with: nil, timeout: 5, completion: {_ in print(Multipeer.transceiver.availablePeers)})
                            }
                            
                        }
                    }
                }
                
            }
        }
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


        
    

//struct LocalPeersView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocalPeersView()
//    }
//}
