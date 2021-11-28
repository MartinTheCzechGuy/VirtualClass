//
//  UserAccountCoordinator.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import Courses
import InstanceProvider
import UserSDK

public final class UserAccountCoordinator: ObservableObject {
    
    enum ActiveScreen: Identifiable {
        case classSearch
        case personalInfo
        case completedCourses
        
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

    @Published var userProfileViewModel: UserProfileViewModel
    @Published private var classSearchViewModel: CourseSearchViewModel?
    @Published private var personalInfoViewModel: UpdatePersonalInfoViewModel?
    @Published private var completedCoursesViewModel: CompletedCoursesViewModel?

    private let navigateToUserProfileSubject = PassthroughSubject<Void, Never>()
    
    private var bag = Set<AnyCancellable>()
    private var classSearchBag = Set<AnyCancellable>()
    private var personalInfoBag = Set<AnyCancellable>()
    private var completedCoursesBag = Set<AnyCancellable>()
    
    private let instanceProvider: InstanceProvider
    
    public init(
        userProfileViewModel: UserProfileViewModel,
        instanceProvider: InstanceProvider
    ) {
        self.userProfileViewModel = userProfileViewModel
        self.instanceProvider = instanceProvider
        self.didLogout = didLogoutSubject.eraseToAnyPublisher()
        self.navigateToUserProfile = navigateToUserProfileSubject.eraseToAnyPublisher()
        
        setupBindings()
    }
    
    private func setupBindings() {
        userProfileViewModel.navigateToClassSearch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.classSearchViewModel = self.instanceProvider.resolve(CourseSearchViewModel.self)
                self.activeScreen = .classSearch
            })
            .store(in: &bag)
        
        userProfileViewModel.navigateToPersonalInfo
            .sink(receiveValue: { [weak self] userAccount in
                guard let self = self else { return }

                self.personalInfoViewModel = self.instanceProvider.resolve(UpdatePersonalInfoViewModel.self)
                self.activeScreen = .personalInfo
            })
            .store(in: &bag)
        
        userProfileViewModel.navigateToCompletedCourses
            .sink(receiveValue: { [weak self] userAccount in
                guard let self = self else { return }

                self.completedCoursesViewModel = self.instanceProvider.resolve(CompletedCoursesViewModel.self)
                self.activeScreen = .completedCourses
            })
            .store(in: &bag)
        
        userProfileViewModel.didLogout
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.didLogoutSubject.send(())
                self.activeScreen = nil
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
                    
                    self.personalInfoBag.removeAll()
                    
                    viewModel?.navigateToUserAccount
                        .sink(receiveValue: {
                            self.personalInfoViewModel = nil
                            self.activeScreen = .none
                        })
                        .store(in: &self.personalInfoBag)
                }
            )
            .store(in: &bag)
        
        $completedCoursesViewModel
            .sink(
                receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.completedCoursesBag.removeAll()
                    
                    viewModel?.navigateBackTap
                        .sink(receiveValue: {
                            self.completedCoursesViewModel = nil
                            self.activeScreen = .none
                        })
                        .store(in: &self.completedCoursesBag)
                }
            )
            .store(in: &bag)
    }
}
