//
//  UserProfileView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Common
import SwiftUI

public struct UserProfileView: View {
    
    @ObservedObject var viewModel: UserProfileViewModel
    
    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                if let userProfile = viewModel.userProfile {
                    List {
                        HStack {
                            Spacer()
                            
                            VStack {
                                Image("profile_picture")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: 300, height: 300, alignment: .center)
                                
                                Text(userProfile.name)
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

                } else {
                    Spacer(minLength: 0)
                    
                    Text("Error loading user profile. You should not be here 👻")
                    
                    Spacer(minLength: 0)
                }
                
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationBarHidden(true)
            .onAppear {
                viewModel.reloadProfile()
            }
        }
    }
}
