//
//  CourseCardsOverviewViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
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
    private let getCoursesUseCase: GetCoursesForLoggedInUserUseCaseType
    
    public init(getCoursesUseCase: GetCoursesForLoggedInUserUseCaseType) {
        self.getCoursesUseCase = getCoursesUseCase
        self.classCardTap = classCardTapSubject.eraseToAnyPublisher()
        self.addClassButtonTap = adddClassSubject.eraseToAnyPublisher()
    
        let loadingDataResult = reloadData
            .flatMap { [weak self] _ -> AnyPublisher<Result<[GenericCourse], Error>, Never> in
                guard let self = self else {
                    return Just(.failure(CoursesCardOverviewError.errorLoadingData(underlyingError: nil)))
                        .eraseToAnyPublisher()
                }
                
                switch self.getCoursesUseCase.courses {
                case .success(let courses):
                    let courses = courses.map { $0 }
                    return Just(.success(courses))
                        .eraseToAnyPublisher()
                case .failure(let error):
                    return Just(.failure(CoursesCardOverviewError.errorLoadingData(underlyingError: error)))
                        .eraseToAnyPublisher()
                }
            }
            .share()
        
        loadingDataResult
            .compactMap(\.success)
            .assign(to: \.studiedClasses, on: self)
            .store(in: &bag)
        
        loadingDataResult
            .compactMap(\.failure)
            .map { _ in "Error loading courses data, please try to load the page again." }
            .assign(to: \.errorLoadingData, on: self)
            .store(in: &bag)
    }
}
