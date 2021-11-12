//
//  LoginView.swift
//  
//
//  Created by Martin on 10.11.2021.
//

import SharedFeatures
import SwiftUI

public struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    @State var email = ""
    @State var password = ""
    
    @Namespace var animation
    
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
                    value: $email,
                    animation: animation
                )
                
                AppTextField(
                    imageSystemName: "lock",
                    title: "PASSWORD",
                    fieldType: .secure,
                    value: $password,
                    animation: animation
                )
                    .padding(.top, 5)
                
                VStack(spacing: 20) {
                    Button(
                        action: { viewModel.loginTap.send((email: email, password: password)) },
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
                        action: { viewModel.registerNewAccountTap.send() },
                        label: {
                            Text("Sign up")
                                .fontWeight(.heavy)
                                .foregroundColor(.golden)
                        }
                    )
                }
                .padding()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView(viewModel: LoginViewModel())
                .previewDevice("iPhone 13")
            LoginView(viewModel: LoginViewModel())
                .previewDevice("iPhone 8")
        }
    }
}
