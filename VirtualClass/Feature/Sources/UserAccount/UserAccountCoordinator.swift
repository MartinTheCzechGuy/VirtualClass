//
//  UserAccountCoordinator.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Classes
import Combine

public final class UserAccountCoordinator: ObservableObject {
    
    @Published public var userAccountViewModel: UserAccountViewModel
    @Published public var classSearchViewModel: ClassSearchViewModel?
    @Published public var personalInfoViewModel: PersonalInfoViewModel?
    @Published public var classListViewModel: ClassListViewModel?
    
    private var bag = Set<AnyCancellable>()
    
    private var classSearchBag = Set<AnyCancellable>()
    private var personalInfoBag = Set<AnyCancellable>()
    private var classOverviewBag = Set<AnyCancellable>()
    
    public init(userAccountViewModel: UserAccountViewModel) {
        self.userAccountViewModel = userAccountViewModel
        
        setupBindings()
    }
    
    deinit {
        print("a slus")
    }
    
    private func setupBindings() {
        userAccountViewModel.navigateToClassSearch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.classSearchViewModel = ClassSearchViewModel()
            })
            .store(in: &bag)
        
        userAccountViewModel.navigateToPersonalInfo
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.personalInfoViewModel = PersonalInfoViewModel()
            })
            .store(in: &bag)
        
        userAccountViewModel.navigateToClassOverview
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.classListViewModel = ClassListViewModel()
            })
            .store(in: &bag)
        
        $classSearchViewModel
            .sink(
                receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.classSearchBag.removeAll()
                    
                    viewModel?.navigateToUserAccount
                        .sink(receiveValue: {
                            self.classSearchViewModel = nil
                        })
                        .store(in: &self.classSearchBag)
                }
            )
            .store(in: &bag)
        
        $personalInfoViewModel
            .sink(
                receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.classSearchBag.removeAll()
                    
                    viewModel?.navigateToUserAccount
                        .sink(receiveValue: {
                            self.personalInfoViewModel = nil
                        })
                        .store(in: &self.personalInfoBag)
                }
            )
            .store(in: &bag)
        
        $classListViewModel
            .sink(
                receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.classSearchBag.removeAll()
                    
                    viewModel?.navigateToUserAccount
                        .sink(receiveValue: {
                            self.classListViewModel = nil
                        })
                        .store(in: &self.classOverviewBag)
                }
            )
            .store(in: &bag)
    }
}
