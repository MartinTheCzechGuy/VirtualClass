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
        if mainCoordinator.dashboardCoordinator != nil {
            instanceProvider.resolve(DashboardView.self)
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
        } else {
            instanceProvider.resolve(WelcomeView.self)
                .fullScreenCover(item: $mainCoordinator.loginViewModel) { _ in
                    instanceProvider.resolve(LoginView.self)
                }
                .fullScreenCover(item: $mainCoordinator.registrationViewModel) { _ in
                    instanceProvider.resolve(RegistrationView.self)
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
