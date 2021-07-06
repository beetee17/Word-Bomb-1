//
//  Styles.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
    let width = UIScreen.main.bounds.width/2
    let height = UIScreen.main.bounds.height*0.07
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.title2.bold())
            .frame(width: width, height: height)
            .foregroundColor(Color.black)
            .contentShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 5))
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
            
    }
}

extension Text {
    func boldText() -> some View {
        self
            .font(.title)
            .fontWeight(.bold)
            .textCase(.uppercase)
    }
}
