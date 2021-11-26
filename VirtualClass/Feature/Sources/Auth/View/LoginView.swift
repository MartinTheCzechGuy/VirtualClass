//
//  LoginView.swift
//  
//
//  Created by Martin on 10.11.2021.
//

import Common
import SwiftUI

public struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
        
    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            WelcomeBackgroundView()
            
            VStack {
                LogoView()
                    .padding(.top, 125)
                
                Spacer(minLength: 0)
                
                AppTextField(
                    imageSystemName: "envelope",
                    title: "EMAIL",
                    fieldType: .text,
                    value: $viewModel.email
                )
                
                AppTextField(
                    imageSystemName: "lock",
                    title: "PASSWORD",
                    fieldType: .secure,
                    value: $viewModel.password
                )
                .padding(.top, 5)
                                
                if let status = viewModel.loginInvalidStatus {
                    TextFieldErrorCaptionView(status: status)
                }
                
                VStack(spacing: 20) {
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
                .padding(.top, 10)
                .padding(.trailing)
                
                Spacer(minLength: 0)
                
                HStack(spacing: 8) {
                    
                    Text("Don't have an account? Register")
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Button(
                        action: { withAnimation { viewModel.registerNewAccountTap.send() } },
                        label: {
                            Text("Sign up")
                                .fontWeight(.heavy)
                                .foregroundColor(.golden)
                        }
                    )
                }
                .padding()
            }
            .padding(.horizontal, 70)
            .preferredColorScheme(.dark)
        }
    }
}
