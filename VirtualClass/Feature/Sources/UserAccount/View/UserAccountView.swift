//
//  File.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import SwiftUI
import InstanceProvider
import Classes

public struct UserAccountView: View {
    
    @ObservedObject var coordinator: UserAccountCoordinator
    
    private let instanceProvider: InstanceProvider
    
    init(coordinator: UserAccountCoordinator, instanceProvider: InstanceProvider) {
        self.coordinator = coordinator
        self.instanceProvider = instanceProvider
    }
    
    public var body: some View {
        instanceProvider.resolve(UserProfileView.self)
            .fullScreenCover(item: $coordinator.activeScreen) { activeScreen in
                switch activeScreen {
                case .classSearch:
                    instanceProvider.resolve(ClassSearchView.self)
                case .personalInfo:
                    instanceProvider.resolve(UpdatePersonalInfoView.self)
                case .classList:
                    instanceProvider.resolve(ClassListView.self)
                }
            }
        
    }
}
