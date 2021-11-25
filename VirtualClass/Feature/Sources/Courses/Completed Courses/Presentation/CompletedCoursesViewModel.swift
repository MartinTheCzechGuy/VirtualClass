//
//  CompletedCoursesViewModel.swift
//  
//
//  Created by Martin on 20.11.2021.
//

import Combine
import Foundation
import UserSDK

enum CompletedCoursesError: Error {
    case errorLoadingData
}

public final class CompletedCoursesViewModel: ObservableObject {
    
    // MARK: - View Model to View
    
    @Published var completedCourses: [GenericCourse] = []
    @Published var showError = false
    
    // MARK: - View to View Model
    
    let goBackTapSubject = PassthroughSubject<Void, Never>()
    let reloadDataSubject = PassthroughSubject<Void, Never>()

    // MARK: - View Model to Coordinator
    
    public let navigateBackTap: AnyPublisher<Void, Never>
    
    // MARK: - Private
    
    private var bag = Set<AnyCancellable>()
    private let getCompletedCoursesUseCase: GetCompletedCoursesForLoggedInUserUseCaseType
    
    init(getCompletedCoursesUseCase: GetCompletedCoursesForLoggedInUserUseCaseType) {
        self.navigateBackTap = goBackTapSubject.eraseToAnyPublisher()
        self.getCompletedCoursesUseCase = getCompletedCoursesUseCase
        
        let loadDataResult = reloadDataSubject
            .flatMap { [weak self] _ -> AnyPublisher<Result<Set<GenericCourse>, CompletedCoursesError>, Never> in
                guard let self = self else {
                    return Just(.failure(CompletedCoursesError.errorLoadingData))
                        .eraseToAnyPublisher()
                }
                
                return self.getCompletedCoursesUseCase.courses
                    .mapError { _ in CompletedCoursesError.errorLoadingData }
                    .mapToResult()
                    .eraseToAnyPublisher()
            }
            .share()
        
        loadDataResult
            .compactMap(\.success)
            .map(Array.init)
            .receive(on: DispatchQueue.main)
            .assign(to: \.completedCourses, on: self)
            .store(in: &bag)
        
        loadDataResult
            .compactMap(\.failure)
            .map { _ in true }
            .receive(on: DispatchQueue.main)
            .assign(to: \.showError, on: self)
            .store(in: &bag)
    }
}

