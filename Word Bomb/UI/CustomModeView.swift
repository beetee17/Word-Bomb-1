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
        VStack(spacing: 50) {
            
            ForEach(items) {
                item in Button(item.name ?? "UNNAMED") {
                    viewModel.selectCustomMode(item)
                }
                .onLongPressGesture(minimumDuration: 1, pressing: { inProgress in
                    print("In progress: \(inProgress)!")
                }) {
                    print("Long pressed!")
                    viewContext.delete(item)
                }
                
            }
            Button("Create New") {
                print("Create New Mode")
                withAnimation { creatingMode = true }
            }
            .sheet(isPresented: $creatingMode, onDismiss: {}) { CustomModeForm() }

            Button("BACK") {
                print("BACK")
                withAnimation { viewModel.changeViewToShow(.modeSelect) }
            }

        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
        .transition(.move(edge: .trailing))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .buttonStyle(MainButtonStyle())
    }

    
    

}




struct CustomModeView_Previews: PreviewProvider {
    static var previews: some View {
        CustomModeView()
    }
}
