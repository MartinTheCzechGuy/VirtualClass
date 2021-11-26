//
//  CourseCardsOverviewViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import CombineExt
import Common
import Foundation
import UserSDK

enum CoursesCardOverviewError: Error {
    case errorLoadingData(underlyingError: Error?)
}

public final class CourseCardsOverviewViewModel: ObservableObject {
    
    @Published var studiedClasses: [GenericCourse] = []
    @Published var errorLoadingData: String? = nil
    
    // MARK: - ViewModel to Coordinator
    let classCardTap: AnyPublisher<GenericCourse, Never>
    let addClassButtonTap: AnyPublisher<Void, Never>
    
    // MARK: - View to View Model
    
    let classCardTapSubject = PassthroughSubject<GenericCourse, Never>()
    let adddClassSubject = PassthroughSubject<Void, Never>()
    let reloadData = PassthroughSubject<Void, Never>()
    
    // MARK: - Private
    
    private var bag = Set<AnyCancellable>()
    private let getCoursesUseCase: GetActiveCoursesForLoggedInUserUseCaseType
    
    public init(getCoursesUseCase: GetActiveCoursesForLoggedInUserUseCaseType) {
        self.getCoursesUseCase = getCoursesUseCase
        self.classCardTap = classCardTapSubject.eraseToAnyPublisher()
        self.addClassButtonTap = adddClassSubject.eraseToAnyPublisher()
    
        let loadingDataResult = reloadData
            .flatMap { [weak self] _ -> AnyPublisher<Result<Set<GenericCourse>, CoursesCardOverviewError>, Never> in
                guard let self = self else {
                    return Just(.failure(CoursesCardOverviewError.errorLoadingData(underlyingError: nil)))
                        .eraseToAnyPublisher()
                }
                
                return self.getCoursesUseCase.courses
                    .mapError { CoursesCardOverviewError.errorLoadingData(underlyingError: $0) }
                    .mapToResult()
                    .eraseToAnyPublisher()
            }
            .share(replay: 1)
        
        loadingDataResult
            .compactMap(\.success)
            .map(Array.init)
            .assign(to: \.studiedClasses, on: self)
            .store(in: &bag)
        
        loadingDataResult
            .compactMap(\.failure)
            .map { _ in "Error loading courses data, please try to load the page again." }
            .assign(to: \.errorLoadingData, on: self)
            .store(in: &bag)
    }
}
