//
//  UserAccountCoordinator.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Classes
import Combine
import InstanceProvider
import UserSDK

public final class UserAccountCoordinator: ObservableObject {
    
    enum ActiveScreen: Identifiable {
        case classSearch
        case personalInfo
        case classList
        
        var id: Self {
            self
        }
    }
    
    // Inputs
    @Published var activeScreen: ActiveScreen? = nil

    // Outputs
    let didLogoutSubject = PassthroughSubject<Void, Never>()
    
    // Actions
    public let didLogout: AnyPublisher<Void, Never>
    public let navigateToUserProfile: AnyPublisher<Void, Never>
    
    // Private
    #warning("TODO - vytvořit vlastní wrapper, který bude dělat to samé (poskytovat publisher for free), ale nebude ho myšlený na vystavování ven")
    @Published private var userAccountViewModel: UserProfileViewModel
    @Published private var classSearchViewModel: ClassSearchViewModel?
    @Published private var personalInfoViewModel: PersonalInfoViewModel?
    @Published private var classListViewModel: ClassListViewModel?
    
    private let navigateToUserProfileSubject = PassthroughSubject<Void, Never>()
    
    private var bag = Set<AnyCancellable>()
    private var classSearchBag = Set<AnyCancellable>()
    private var personalInfoBag = Set<AnyCancellable>()
    private var classListBag = Set<AnyCancellable>()
    
    private let instanceProvider: InstanceProvider
    
    public init(
        userAccountViewModel: UserProfileViewModel,
        instanceProvider: InstanceProvider
    ) {
        self.userAccountViewModel = userAccountViewModel
        self.instanceProvider = instanceProvider
        self.didLogout = didLogoutSubject.eraseToAnyPublisher()
        self.navigateToUserProfile = navigateToUserProfileSubject.eraseToAnyPublisher()
        
        setupBindings()
    }
    
    private func setupBindings() {
        userAccountViewModel.navigateToClassSearch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.classSearchViewModel = self.instanceProvider.resolve(ClassSearchViewModel.self)
                self.activeScreen = .classSearch
            })
            .store(in: &bag)
        
        userAccountViewModel.navigateToPersonalInfo
            .sink(receiveValue: { [weak self] userAccount in
                guard let self = self else { return }

                self.personalInfoViewModel = self.instanceProvider.resolve(PersonalInfoViewModel.self)
                self.activeScreen = .personalInfo
            })
            .store(in: &bag)
        
        userAccountViewModel.navigateToClassList
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.classListViewModel = self.instanceProvider.resolve(ClassListViewModel.self)
                self.activeScreen = .classList
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
                        .sink(receiveValue: {
                            self.classSearchViewModel = nil
                            self.activeScreen = .none
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
                            self.activeScreen = .none
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
                            self.activeScreen = .none
                        })
                        .store(in: &self.classListBag)
                }
            )
            .store(in: &bag)
    }
}
