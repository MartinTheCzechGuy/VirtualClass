//
//  CompletedCoursesViewModel.swift
//  
//
//  Created by Martin on 20.11.2021.
//

import Combine
import Foundation
import UserSDK

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
            .compactMap { [weak self] _ in
                self?.getCompletedCoursesUseCase.courses
            }
            .share()
        
        loadDataResult
            .compactMap(\.success)
            .map { Array($0) }
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

