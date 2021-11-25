//
//  UserAccountView.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Courses
import InstanceProvider
import SwiftUI

public struct UserAccountView: View {
    
    @ObservedObject var coordinator: UserAccountCoordinator
    
    private let instanceProvider: InstanceProvider
    
    init(coordinator: UserAccountCoordinator, instanceProvider: InstanceProvider) {
        self.coordinator = coordinator
        self.instanceProvider = instanceProvider
    }
    
    public var body: some View {
        instanceProvider.resolve(UserProfileView.self)
            .fullScreenCover(
                item: $coordinator.activeScreen,
                onDismiss: { coordinator.userProfileViewModel.reloadProfileSubject.send() }
            ) { activeScreen in
                switch activeScreen {
                case .classSearch:
                    instanceProvider.resolve(CourseSearchView.self)
                case .personalInfo:
                    instanceProvider.resolve(UpdatePersonalInfoView.self)
                case .completedCourses:
                    instanceProvider.resolve(CompletedCoursesView.self)
                }
            }
        
    }
}
