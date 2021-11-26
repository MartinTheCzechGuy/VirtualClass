//
//  ClassDetailViewModel.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Combine
import UserSDK

final class CourseDetailViewModel: ObservableObject {
    
    // MARK: - VM to View
    
    @Published var courseDetail: CourseDetailModel
    @Published var errorMessage: String? = nil

    // MARK: - VM to Coordinator
    
    public let goBackTap: AnyPublisher<Void, Never>
    
    // MARK: - View to View Model
    
    let goBackSubject = PassthroughSubject<Void, Never>()
    let removeCourseTap = PassthroughSubject<String, Never>()
    let markCourseCompleteTap = PassthroughSubject<String, Never>()

    // MARK: - Private
    
    private let removeCourseFromStudiedUseCase: RemoveCourseFromStudiedUseCaseType
    private let markCourseCompleteUseCase: MarkCourseCompleteUseCaseType
    private var bag = Set<AnyCancellable>()
    
    init(
        removeCourseFromStudiedUseCase: RemoveCourseFromStudiedUseCaseType,
        markCourseCompleteUseCase: MarkCourseCompleteUseCaseType,
        courseDetail: CourseDetailModel
    ) {
        self.removeCourseFromStudiedUseCase = removeCourseFromStudiedUseCase
        self.markCourseCompleteUseCase = markCourseCompleteUseCase
        self.courseDetail = courseDetail
        self.goBackTap = goBackSubject.eraseToAnyPublisher()
        
        removeCourseTap
            .flatMap { [weak self] ident -> AnyPublisher<Result<Void, UserRepositoryError>, Never> in
                guard let self = self else {
                    return Empty()
                        .setFailureType(to: UserRepositoryError.self)
                        .mapToResult()
                        .eraseToAnyPublisher()
                }
                
                return self.removeCourseFromStudiedUseCase.remove(courseIdent: ident)
                    .mapToResult()
                    .eraseToAnyPublisher()
            }
            .sink(
                receiveValue: { [weak self] result in
                    switch result {
                    case .success:
                        self?.goBackSubject.send()
                    case .failure:
                        self?.errorMessage = "Error removing course"
                    }
                }
            )
            .store(in: &bag)
        
        markCourseCompleteTap
            .flatMap { [weak self] ident -> AnyPublisher<Result<Void, UserRepositoryError>, Never> in
                guard let self = self else {
                    return Empty()
                        .setFailureType(to: UserRepositoryError.self)
                        .mapToResult()
                        .eraseToAnyPublisher()
                }
                
                return self.markCourseCompleteUseCase.complete(courseIdent: ident)
                    .mapToResult()
                    .eraseToAnyPublisher()
            }
            .sink(
                receiveValue: { [weak self] result in
                    switch result {
                    case .success:
                        self?.goBackSubject.send()
                    case .failure:
                        self?.errorMessage = "Error marking course complete."
                    }
                }
            )
            .store(in: &bag)
    }
}

extension CourseDetailViewModel: Equatable {
    static func == (lhs: CourseDetailViewModel, rhs: CourseDetailViewModel) -> Bool {
        lhs.courseDetail == rhs.courseDetail
    }
}
extension CourseDetailViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(courseDetail)
    }
}
