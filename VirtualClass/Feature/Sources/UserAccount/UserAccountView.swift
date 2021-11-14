//
//  UserAccountView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Common
import SwiftUI

public struct UserAccountView: View {
    
    @ObservedObject var viewModel: UserAccountViewModel
    
    public init(viewModel: UserAccountViewModel) {
        self.viewModel = viewModel
        
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                List {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Image("profile_picture")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(width: 300, height: 300, alignment: .center)
                            
                            Text("Martin Kamínek")
                        }
                        
                        Spacer()
                    }
                    .listRowBackground(Color(.systemGroupedBackground))
                    
                    Section(header: Text("My Account")) {
                        Text("Personal info")
                            .onTapGesture {
                                viewModel.personalInfoTap.send()
                            }
                    }
                    
                    Section(header: Text("My classes")) {
                        Text("Currently studied classes")
                            .onTapGesture {
                                viewModel.currentlyStudiedClassesTap.send()
                            }
                        
                        Text("Add new class")
                            .onTapGesture {
                                viewModel.addNewClassTap.send()
                            }
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button(
                            action: { viewModel.logoutTap.send() },
                            label: {
                                Text("Log out")
                            }
                        )
                            .buttonStyle(AppBlackButtonStyle())
                            .padding(.bottom, 50)
                        
                        Spacer ()
                    }
                    .listRowBackground(Color(.systemGroupedBackground))
                    
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}
