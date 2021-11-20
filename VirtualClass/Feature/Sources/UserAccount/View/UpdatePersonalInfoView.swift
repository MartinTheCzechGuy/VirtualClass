//
//  UpdatePersonalInfoView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Common
import SwiftUI

public struct UpdatePersonalInfoView: View {
    
    @ObservedObject var viewModel: UpdatePersonalInfoViewModel
    
    public init(viewModel: UpdatePersonalInfoViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
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
                value: $viewModel.userInfo.email
            )
            
            AppTextField(
                imageSystemName: "person",
                title: "Full name",
                fieldType: .text,
                value: $viewModel.userInfo.name
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
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            viewModel.reloadUserData()
        }
    }
}
