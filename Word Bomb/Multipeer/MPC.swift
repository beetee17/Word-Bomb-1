//
//  MPC.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation
import MultipeerConnectivity

extension WordBombGameViewModel: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        var status = ""
        
        switch state {
        case .connecting:
            
            DispatchQueue.main.async {
                self.advertising = false
            }
            
            status = ("\(peerId.displayName): connecting")
            
        case .connected:
            status = ("\(peerId.displayName): connected to HOST")
            
            if deviceIsHost(self) {
                status = ("\(peerId.displayName) is HOST")
                setPlayers(session.connectedPeers)
                
                DispatchQueue.main.async {
                    self.showHostingAlert = true

                    let alert = UIAlertController(title: "You are the host!",
                                                  message: "Connected devices will see your game!",
                                                  preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK",
                                                  style:UIAlertAction.Style.default,
                                                  handler: nil))
                    
                    UIApplication.shared.windows.first?.rootViewController?.presentedViewController?.present(alert,
                                 animated: true,
                                 completion: { self.showHostingAlert = false })
                }
            }
        case .notConnected:
            status = ("\(peerId.displayName): not connected")
        default:
            status = ("\(peerId.displayName): unknown")
        }
        DispatchQueue.main.async {
            self.mpcStatus = status
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // when peer receives input data
        if let model = try? JSONDecoder().decode(WordBombGame.self, from: data) {
 
            DispatchQueue.main.async {
                print("received\n\(model)")
                self.setModel(model)
            }
        }
        else {
            let responseDict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
            if let inputData = responseDict?["input"] as? String {
                DispatchQueue.main.async {
                    print("received input")
                    if deviceIsHost(self) {
                        print("processing input on host")
                        self.input = inputData
                        self.processPeerInput()
                        
                    }
                }
            }
        }
    }
        
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}
extension WordBombGameViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // accepts invitation from peer
        invitationHandler(true, session)
    }
}

extension WordBombGameViewModel: MCBrowserViewControllerDelegate {
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }
}

// MARK: - Utility Functions
func isMultiplayer(_ viewModel: WordBombGameViewModel) -> Bool {
    return viewModel.session.connectedPeers.count > 0
}

func deviceIsHost(_ viewModel: WordBombGameViewModel) -> Bool {
    for peer in viewModel.session.connectedPeers {
        if peer.displayName < viewModel.peerId.displayName {
            return false
        }
    }
    return true
}
