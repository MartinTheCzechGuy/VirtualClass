//
//  PersonalInfoView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import SharedFeatures
import SwiftUI

public struct PersonalInfoView: View {
    
    @ObservedObject var viewModel: PersonalInfoViewModel
    
    @State var name = "my email"
    @State var email = "my name"
    
    @Namespace var animation
    
    public init(viewModel: PersonalInfoViewModel) {
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
                title: "EMAIL",
                fieldType: .text,
                value: $email,
                animation: animation
            )
            
            AppTextField(
                imageSystemName: "person",
                title: "NAME",
                fieldType: .text,
                value: $name,
                animation: animation
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
    }
}

struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInfoView(viewModel: PersonalInfoViewModel())
    }
}
