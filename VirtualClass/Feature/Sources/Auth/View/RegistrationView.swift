//
//  SwiftUIView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Common
import SwiftUI

public struct RegistrationView: View {
    
    @ObservedObject private var viewModel: RegistrationViewModel
    
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var repeatedPassword = ""
        
    public init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 30) {
                LogoView()
                    .padding(.top, 125)
                
                VStack(spacing: 5) {
                    AppTextField(
                        imageSystemName: "person",
                        title: "Full name",
                        fieldType: .text,
                        value: $name
                    )
                    
                    AppTextField(
                        imageSystemName: "envelope",
                        title: "Email",
                        fieldType: .text,
                        value: $email
                    )
                    
                    AppTextField(
                        imageSystemName: "lock",
                        title: "Password",
                        fieldType: .secure,
                        value: $password
                    )
                    
                    AppTextField(
                        imageSystemName: "lock",
                        title: "Password again",
                        fieldType: .secure,
                        value: $repeatedPassword
                    )
                }
                
                if let status = viewModel.registrationInvalidStatus {
                    TextFieldErrorCaptionView(status: status)
                }
                
                VStack(spacing: 15) {
                    Button(
                        action: { viewModel.registerTap.send(.init(email: email, password1: password, password2: repeatedPassword, name: name)) },
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
                
                HStack {
                    Text("Already have an account?")
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Button(
                        action: {
                            viewModel.alreadyHaveAccountTap.send()
                        },
                        label: {
                            Text("Sign in")
                                .fontWeight(.heavy)
                                .foregroundColor(.golden)
                        }
                    )
                }
                .padding()
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .background(
            WelcomeBackgroundView()
        )
    }
}

