//
//  HomeCoordinator.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Combine
import Foundation
import InstanceProvider

final class HomeCoordinator: ObservableObject {
    
    enum ActiveScreen: Hashable, Identifiable {
        case classDetail(Class)
        case addingClass
        
        var id: Self {
            self
        }
    }
    
    // MARK: - Coordinator to View
    @Published var activeScreen: ActiveScreen? = nil
    
    // MARK: - Private
    
    @Published private var classCardView: ClassesCardOverviewViewModel
    @Published private var classDetailViewModel: ClassDetailViewModel?
    @Published private var classSearchViewModel: ClassSearchViewModel?
    
    // MARK: - Private
    
    private let instanceProvider: InstanceProvider
    
    private var bag = Set<AnyCancellable>()
    private var classSearchBag = Set<AnyCancellable>()
    private var classDetailBag = Set<AnyCancellable>()

    init(instanceProvider: InstanceProvider, classCardView: ClassesCardOverviewViewModel) {
        self.instanceProvider = instanceProvider
        self.classCardView = classCardView
        
        setupBindings()
    }
    
    private func setupBindings() {
        classCardView.addClassButtonTap
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.classSearchViewModel = self.instanceProvider.resolve(ClassSearchViewModel.self)
                self.activeScreen = .addingClass
            })
            .store(in: &bag)
        
        classCardView.classCardTap
            .sink(receiveValue: { [weak self] classData in
                guard let self = self else { return }

                self.classDetailViewModel = self.instanceProvider.resolve(ClassDetailViewModel.self, argument: classData)
                self.activeScreen = .classDetail(classData)
            })
            .store(in: &bag)
        
        $classSearchViewModel
            .compactMap { $0 }
            .sink(
                receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.classSearchBag.removeAll()
                    
                    viewModel.goBackTap
                        .merge(with: viewModel.classedAddedSuccessfully)
                        .sink(receiveValue: { [weak self] _ in
                            guard let self = self else { return }
                            
                            self.classSearchViewModel = nil
                            self.activeScreen = .none
                        })
                        .store(in: &self.classSearchBag)
                }
            )
            .store(in: &bag)
        
        $classDetailViewModel
            .compactMap { $0 }
            .sink(
                receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.classDetailBag.removeAll()
                    
                    viewModel.goBackTap
                        .sink(receiveValue: { [weak self] _ in
                            guard let self = self else { return }
                            
                            self.classDetailViewModel = nil
                            self.activeScreen = .none
                        })
                        .store(in: &self.classDetailBag)
                }
            )
            .store(in: &bag)
    }
}
