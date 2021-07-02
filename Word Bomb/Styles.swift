//
//  Styles.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.title.bold())
            .frame(width:UIScreen.main.bounds.width/2,
                   height:UIScreen.main.bounds.height*0.05)
            .foregroundColor(Color.black)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 5))
    }
}

