//
//  DashboardView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Calendar
import Classes
import UserAccount
import SwiftUI

public struct DashboardView: View {
    
    @ObservedObject var coordinator: DashboardCoordinator
    
    public init(coordinator: DashboardCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        if let classSearchVM = coordinator.classSearchViewModel {
            
            ClassSearchView(viewModel: classSearchVM)
                .preferredColorScheme(.light)
            
        } else if let personalInfoVM = coordinator.personalInfoViewModel {
            
            PersonalInfoView(viewModel: personalInfoVM)
                .preferredColorScheme(.light)
            
        } else if let classListViewModel = coordinator.classListViewModel {
            
            ClassListView(viewModel: classListViewModel)
                .preferredColorScheme(.dark)
            
        } else {
            
            TabView {
                ClassesCardOverviewView(viewModel: coordinator.classOverviewViewModel)
                    .tabItem {
                        Label("", systemImage: "house")
                    }
                
                CalendarView(viewModel: coordinator.calendarViewModel)
                    .tabItem {
                        Label("", systemImage: "calendar")
                    }
                
                UserAccountView(viewModel: coordinator.userAccountCoordinator.userAccountViewModel)
                    .tabItem {
                        Label("", systemImage: "person")
                    }
            }
            .preferredColorScheme(.light)
        }
    }
}

//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView(
//            coordinator: .init(
//                userAccountCoordinator: .init(userAccountViewModel: .init()),
//                classOverviewViewModel: .init(),
//                calendarViewModel: .init()
//            )
//        )
//    }
//}
