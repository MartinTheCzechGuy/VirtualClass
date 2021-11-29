//
//  WelcomeView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Common
import SwiftUI

public struct WelcomeView: View {
    
    @ObservedObject var viewModel: WelcomeViewModel
    
    @State var titlePadding: CGFloat = 0
    @State var buttonStackPadding: CGFloat = 0
    
    public init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            LogoView()
                .padding(.top, titlePadding)
                .animation(.easeIn(duration: 0.8))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
                        titlePadding = 125
                    }
                }
            
            Spacer(minLength: 0)
            
            VStack(spacing: 15) {
                Button(
                    action: { viewModel.signInTap.send(()) },
                    label: {
                        Text("Sign In")
                    }
                )
                    .buttonStyle(AppGoldenButtonStyle())
                
                Button(
                    action: { viewModel.signUpTap.send(()) },
                    label: {
                        Text("Sign up")
                    }
                )
                    .buttonStyle(AppGoldenButtonStyle())
            }
            .padding(.bottom, buttonStackPadding)
            .animation(.easeInOut(duration: 0.8))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
                    buttonStackPadding = 60
                }
            }
        }
        .preferredColorScheme(.dark)
        .background(
            WelcomeBackgroundView()
        )
    }
}
