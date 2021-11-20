//
//  HomeView.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import SwiftUI
import InstanceProvider
import UserSDK

public struct HomeView: View {
    
    @ObservedObject var coordinator: HomeCoordinator
    
    private let instanceProvider: InstanceProvider
    
    init(instanceProvider: InstanceProvider, coordinator: HomeCoordinator) {
        self.instanceProvider = instanceProvider
        self.coordinator = coordinator
    }
    
    public var body: some View {
        instanceProvider.resolve(CourseCardsOverviewView.self)
            .fullScreenCover(
                item: $coordinator.activeScreen,
                onDismiss: { coordinator.classCardViewModel.reloadData.send() }
            ) { activeScreen in
                switch activeScreen {
                case .courseDetail(let viewModel):
                    CourseDetailView(viewModel: viewModel)
                case .addingClass:
                    instanceProvider.resolve(ClassSearchView.self)
                }
            }
    }
}

