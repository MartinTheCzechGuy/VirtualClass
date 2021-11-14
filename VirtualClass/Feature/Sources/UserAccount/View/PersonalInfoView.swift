//
//  PersonalInfoView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Common
import SwiftUI

public struct PersonalInfoView: View {
    
    @ObservedObject var viewModel: PersonalInfoViewModel
            
    public init(viewModel: PersonalInfoViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            
            if var personalInfo = viewModel.userInfo {
                let nameBinding = Binding<String>(
                    get: { return personalInfo.name },
                    set: { personalInfo.name = $0 }
                )
                let emailBinding = Binding<String>(
                    get: { return personalInfo.email },
                    set: { personalInfo.email = $0 }
                )
                
                HStack {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(Color.black)
                        .onTapGesture {
                            withAnimation {
                                viewModel.goBackTap.send()
                            }
                        }
                    
                    Spacer(minLength: 0)
                }
                .padding()
                
                Image("profile_picture")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 300, height: 300, alignment: .center)
                
                AppTextField(
                    imageSystemName: "envelope",
                    title: "Email address",
                    fieldType: .text,
                    value: emailBinding
                )
                
                AppTextField(
                    imageSystemName: "person",
                    title: "Full name",
                    fieldType: .text,
                    value: nameBinding
                )
                
                Spacer(minLength: 0)
                
                Button(
                    action: { viewModel.saveChangesTap.send() },
                    label: {
                        Text("Save changes")
                    }
                )
                    .buttonStyle(AppBlackButtonStyle())
                    .padding(.bottom, 50)
                
            } else {
                Spacer(minLength: 0)
                
                Text("Error loading user profile. You should not be here 👻")
                
                Spacer(minLength: 0)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            viewModel.reloadUserData()
        }
    }
}
