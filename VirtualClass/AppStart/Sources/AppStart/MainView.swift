//
//  MainView.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Auth
import Dashboard
import SwiftUI

public struct MainView: View {
        
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var mainCoordinator: MainCoordinator
    
    init(mainCoordinator: MainCoordinator) {
        self.mainCoordinator = mainCoordinator
    }
        
    public var body: some View {
        if let dashboardCoordinator = mainCoordinator.dashboardCoordinator {
            DashboardView(coordinator: dashboardCoordinator)
        } else {
            WelcomeView(viewModel: mainCoordinator.welcomeViewModel)
                .fullScreenCover(item: $mainCoordinator.loginViewModel) { viewModel in
                    LoginView(viewModel: viewModel)
                }
                .fullScreenCover(item: $mainCoordinator.registrationViewModel) { viewModel in
                    RegistrationView(viewModel: viewModel)
                }
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .background:
                        print("[APP STATE] - going into background")
                        // tady bys mohl ukladat stav do DB kdyz jdes do pozadi
        //                databaseInteracting.save
                    case .inactive:
                        print("[APP STATE] - going into inactive")
                    case .active:
                        print("[APP STATE] - becoming active again")
                    @unknown default:
                        print("[APP STATE] - Catched aditional unknown phase")
                    }
                }
                .preferredColorScheme(.dark)

        }
    }
}

enum Tab: String {
    case home = "home"
    case calendar = "calendar"
    case account = "account"
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(mainCoordinator: .init(welcomeViewModel: .init()))
    }
}
