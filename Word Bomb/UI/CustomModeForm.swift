//
//  CustomModeForm.swift
//  Word Bomb
//
//  Created by Brandon Thio on 7/7/21.
//

import SwiftUI

struct CustomModeForm: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @State private var selectedGameMode = "EXACT"
    @State private var modeName = ""
    @State private var words = ""
    @State private var instruction = ""
    
    
    var body: some View {
        Form {
            Section(header: Text("Game Mode")) {
                Picker("Select a color", selection: $selectedGameMode) {
                    ForEach(["EXACT", "CONTAINS"], id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            Section(header: Text("Mode Name")) {
                TextField("Enter the name of your mode", text: $modeName)
            }
            Section(header: Text("Instruction")) {
                TextField("Enter user instruction here", text: $instruction)
            }

            Section(header: Text("Words")) {
                
                ZStack {
                    TextEditor(text: $words)
                }
            }

            Button("Save changes") {
                let newItem = Item(context: viewContext)
                newItem.name = modeName
                let data = words.components(separatedBy: "\n")
                newItem.data = encodeStrings(data.map {
                    $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
               })
                print(newItem.data)
                newItem.gameType = "EXACT"
                newItem.instruction = instruction
                addItem(newItem)
            }
            .buttonStyle(MainButtonStyle())
        }
    }
    
    private func addItem(_ item: Item) {
        withAnimation {
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct CustomModeForm_Previews: PreviewProvider {
    static var previews: some View {
        CustomModeForm()
    }
}
