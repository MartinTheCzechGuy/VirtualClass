//
//  WelcomeBackgroundView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import SwiftUI

struct WelcomeBackgroundView: View {
    var body: some View {
        ZStack {
            Color.black
        
            Image("background")
                .resizable()
                .scaledToFill()
                .opacity(0.6)
        }
        .ignoresSafeArea()
    }
}

struct WelcomeBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeBackgroundView()
                .previewDevice("iPhone 13")
            WelcomeBackgroundView()
                .previewDevice("iPhone 8")
        }
    }
}
