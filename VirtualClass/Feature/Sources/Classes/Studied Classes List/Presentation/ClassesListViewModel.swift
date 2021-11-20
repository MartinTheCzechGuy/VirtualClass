//
//  ClassListViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import Foundation
import UserSDK

public final class ClassListViewModel: ObservableObject {

    // MARK: - View Model to View
    
    @Published var studiedClasses: [GenericCourse] = []
    
    // MARK: - View to View Model
    
    let reloadDataSubject = PassthroughSubject<Void, Never>()
    let goBackTap = PassthroughSubject<Void, Never>()

    // MARK: - View Model to Coordinator
    
    public let navigateToUserAccount: AnyPublisher<Void, Never>
    
    // MARK: - Private
    
    private let getCoursesForLoggedInUserUseCase: GetCoursesForLoggedInUserUseCaseType
    private var bag = Set<AnyCancellable>()
    
    public init(getCoursesForLoggedInUserUseCase: GetCoursesForLoggedInUserUseCaseType) {
        self.getCoursesForLoggedInUserUseCase = getCoursesForLoggedInUserUseCase
        self.navigateToUserAccount = goBackTap.eraseToAnyPublisher()
        
        reloadDataSubject
            .compactMap { [weak self] _ in
                self?.getCoursesForLoggedInUserUseCase.courses
            }
            .compactMap(\.success)
            .map { Array($0) }
            .assign(to: \.studiedClasses, on: self)
            .store(in: &bag)
    }
}
