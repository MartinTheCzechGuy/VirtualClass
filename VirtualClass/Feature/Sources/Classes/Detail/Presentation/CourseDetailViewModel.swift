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
            .sink(
                receiveValue: { [weak self] ident in
                    _ = self?.removeCourseFromStudiedUseCase.remove(courseIdent: ident)
                    self?.goBackSubject.send()
                }
            )
            .store(in: &bag)
        
        markCourseCompleteTap
            .sink(
                receiveValue: { [weak self] ident in
                    _ = self?.markCourseCompleteUseCase.complete(courseIdent: ident)
                    self?.goBackSubject.send()
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
