//
//  HomeView.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import SwiftUI
import InstanceProvider

public struct HomeView: View {
    
    @ObservedObject var coordinator: HomeCoordinator
    
    private let instanceProvider: InstanceProvider
    
    init(instanceProvider: InstanceProvider, coordinator: HomeCoordinator) {
        self.instanceProvider = instanceProvider
        self.coordinator = coordinator
    }
    
    public var body: some View {
        instanceProvider.resolve(ClassesCardOverviewView.self)
            .fullScreenCover(item: $coordinator.activeScreen) { activeScreen in
                switch activeScreen {
                case .classDetail(let classInfo):
                    instanceProvider.resolve(ClassDetailView.self, argument: classInfo)
                case .addingClass:
                    instanceProvider.resolve(ClassSearchView.self)
                }
            }
    }
}

