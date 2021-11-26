//
//  CourseSearchViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import CombineExt
import Foundation
import UserSDK

enum CourseSearchError: String, Error, Identifiable {
    case errorLoadingCourses = "Loading course data failed."
    case errorFindingCourses = "Could not find the courses. Please try again"
    case errorAddingCourses = "Error adding courses among active."
    
    var id: Self {
        self
    }
}

public final class CourseSearchViewModel: ObservableObject {
    
    // MARK: - View Model to View
    
    @Published var searchedCourse = "" {
        didSet {
            if searchedCourse.count > 6 && oldValue.count <= 6 {
                searchedCourse = oldValue
            }
        }
    }
    @Published var searchResult: [SearchedCourse] = []
    @Published var showError: CourseSearchError? = nil
    
    // MARK: - View to View Model
    
    let goBackTapSubject = PassthroughSubject<Void, Never>()
    let addSelectedTapSubject = PassthroughSubject<Void, Never>()
    let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - View Model to Coordinator
    
    public let goBackTap: AnyPublisher<Void, Never>
    public let classedAddedSuccessfully: AnyPublisher<Void, Never>
    
    // MARK: - Private
    
    private let findPossibleToEnrollCoursesUseCase: GetCoursesToEnrollUseCaseType
    private let addCoursesUseCase: AddToUserActiveCoursesUseCaseType
    
    private let classedAddedSuccessfullySubject = PassthroughSubject<Void, Never>()
    private var bag: Set<AnyCancellable> = []
    
    public init(
        findPossibleToEnrollCoursesUseCase: GetCoursesToEnrollUseCaseType,
        addCoursesUseCase: AddToUserActiveCoursesUseCaseType
    ) {
        self.findPossibleToEnrollCoursesUseCase = findPossibleToEnrollCoursesUseCase
        self.addCoursesUseCase = addCoursesUseCase
        self.goBackTap = goBackTapSubject.eraseToAnyPublisher()
        self.classedAddedSuccessfully = classedAddedSuccessfullySubject.eraseToAnyPublisher()
        
        setupBindings()
    }
    
    private func setupBindings() {
        let availableCourses = reloadDataSubject
            .flatMap { [weak self] courseIdent -> AnyPublisher<Result<Set<GenericCourse>, CourseSearchError>, Never> in
                guard let self = self else {
                    return Just(.failure(CourseSearchError.errorLoadingCourses))
                        .eraseToAnyPublisher()
                }
                
                return self.findPossibleToEnrollCoursesUseCase.allAvailable
                    .mapError { _ in CourseSearchError.errorLoadingCourses }
                    .mapToResult()
                    .eraseToAnyPublisher()
            }
            .share(replay: 1)

        availableCourses
            .compactMap(\.success)
            .mapElement {
                SearchedCourse(
                    ident: $0.ident,
                    name: $0.name,
                    isSelected: false
                )
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.searchResult, on: self)
            .store(in: &bag)
        
        availableCourses
            .compactMap(\.failure)
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: \.showError, on: self)
            .store(in: &bag)
        
        let foundCourses = $searchedCourse
            .compactMap { $0.count == .zero ? nil : $0 }
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.global(qos: .background))
            .flatMap { [weak self] courseIdent -> AnyPublisher<Result<Set<GenericCourse>, CourseSearchError>, Never> in
                guard let self = self else {
                    return Just(.failure(CourseSearchError.errorFindingCourses))
                        .eraseToAnyPublisher()
                }
                
                return self.findPossibleToEnrollCoursesUseCase.find(ident: courseIdent)
                    .mapError { _ in CourseSearchError.errorFindingCourses }
                    .mapToResult()
                    .eraseToAnyPublisher()
            }
            .share(replay: 1)

        foundCourses
            .compactMap(\.success)
            .mapElement {
                SearchedCourse(
                    ident: $0.ident,
                    name: $0.name,
                    isSelected: false
                )
                
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.searchResult, on: self)
            .store(in: &bag)
        
        foundCourses
            .compactMap(\.failure)
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: \.showError, on: self)
            .store(in: &bag)
        
        let addClassesResult = addSelectedTapSubject
            .compactMap { [weak self] _ -> [String]? in
                guard let self = self else { return nil }
                
                return self.searchResult
                    .filter { $0.isSelected }
                    .map(\.ident)
            }
            .flatMap { [weak self] courseIdents -> AnyPublisher<Result<Void, CourseSearchError>, Never> in
                guard let self = self else {
                    return Just(.failure(CourseSearchError.errorAddingCourses)).eraseToAnyPublisher()
                }
                
                return self.addCoursesUseCase.add(idents: courseIdents)
                    .mapError { _ in CourseSearchError.errorAddingCourses }
                    .mapToResult()
                    .eraseToAnyPublisher()
            }
            .share(replay: 1)

        addClassesResult
            .compactMap(\.success)
            .sink(receiveValue: { [weak self] _ in
                self?.classedAddedSuccessfullySubject.send()
            })
            .store(in: &bag)
        
        addClassesResult
            .compactMap(\.failure)
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: \.showError, on: self)
            .store(in: &bag)
    }
}
