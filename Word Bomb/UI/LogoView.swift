//
//  Logo.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        VStack(spacing: -20) {
            Image("Word")
            Image("Bomb")
            Spacer()
        }
        .padding(.top, 100)
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
