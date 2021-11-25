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
        switch mainCoordinator.activeScreen {
        case .dashboard:
            instanceProvider.resolve(DashboardView.self)
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .background:
                        print("[APP STATE] - going into background")
                    default:
                        return
                    }
                }
        case .auth:
            instanceProvider.resolve(AuthView.self)
                .preferredColorScheme(.dark)
        }
        
    }
}
