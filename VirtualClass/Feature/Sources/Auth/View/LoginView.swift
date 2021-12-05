//
//  LoginView.swift
//  
//
//  Created by Martin on 10.11.2021.
//

import Common
import SwiftUI

public struct LoginView: View {
    
    @ObservedObject private var viewModel: LoginViewModel
    
    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: 30) {
            LogoView()
                .padding(.top, 125)
            
            Spacer(minLength: 0)
            
            VStack(spacing: 5) {
                AppTextField(
                    imageSystemName: "envelope",
                    title: "Email",
                    fieldType: .text,
                    value: $viewModel.email
                )
                
                AppTextField(
                    imageSystemName: "lock",
                    title: "Password",
                    fieldType: .secure,
                    value: $viewModel.password
                )
            }
            
            if let status = viewModel.loginInvalidStatus {
                TextFieldErrorCaptionView(status: status)
            }
            
            VStack(spacing: 15) {
                Button(
                    action: { viewModel.loginTap.send((email: viewModel.email, password: viewModel.password)) },
                    label: {
                        Text("Login")
                    }
                )
                    .buttonStyle(AppGoldenButtonStyle())
                
                Button(
                    action: { viewModel.goBackTap.send() },
                    label: {
                        Text("Go back")
                    }
                )
                    .buttonStyle(AppGoldenButtonStyle())
            }
            .padding()
            
            Spacer(minLength: 0)
            
            HStack {
                Text("Don't have an account? ")
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Button(
                    action: { withAnimation { viewModel.registerNewAccountTap.send() } },
                    label: {
                        Text("Register")
                            .fontWeight(.heavy)
                            .foregroundColor(.golden)
                    }
                )
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .background(
            WelcomeBackgroundView()
        )
    }
}
