//
//  CustomModeView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 7/7/21.
//

import SwiftUI
import CoreData


struct CustomModeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: WordBombGameViewModel

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var creatingMode = false

    var body: some View {
        Color.clear
        VStack(spacing: 50) {
            
            ForEach(items) {
                item in Button(item.name ?? "UNNAMED") {
                    viewModel.selectCustomMode(item)
                }
                .buttonStyle(MainButtonStyle())
                .contextMenu {
                    Button(action: {
                            // to avoid glitchy animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: { viewContext.delete(item) })
                        
                    }) {
                        HStack {
                            Text("Delete \"\(item.name ?? "UNAMED" )\"")
                            Image(systemName: "trash.fill")
                        }
                    }
                }
                
            }
            Button("CREATE NEW") {
                print("Create New Mode")
                withAnimation { creatingMode = true }
            }
            .buttonStyle(MainButtonStyle())
            .sheet(isPresented: $creatingMode, onDismiss: {}) { CustomModeForm() }

            Button("BACK") {
                print("BACK")
                withAnimation { viewModel.changeViewToShow(.modeSelect) }
            }
            .buttonStyle(MainButtonStyle())

        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
        .transition(.move(edge: .trailing))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        
    }

    
    

}




struct CustomModeView_Previews: PreviewProvider {
    static var previews: some View {
        CustomModeView()
    }
}
