//
//  DashboardView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Calendar
import Courses
import InstanceProvider
import UserAccount
import SwiftUI

public struct DashboardView: View {
    
    @ObservedObject var coordinator: DashboardCoordinator

    private let instanceProvider: InstanceProvider
    
    public init(coordinator: DashboardCoordinator, instanceProvider: InstanceProvider) {
        self.coordinator = coordinator
        self.instanceProvider = instanceProvider
    }
    
    public var body: some View {
        TabView {
            instanceProvider.resolve(HomeView.self)
                .tabItem {
                    Label("", systemImage: "house")
                }
            
            instanceProvider.resolve(CalendarView.self)
                .tabItem {
                    Label("", systemImage: "calendar")
                }
            
            instanceProvider.resolve(UserAccountView.self)
                .tabItem {
                    Label("", systemImage: "person")
                }
        }
        .preferredColorScheme(.light)
    }
}
