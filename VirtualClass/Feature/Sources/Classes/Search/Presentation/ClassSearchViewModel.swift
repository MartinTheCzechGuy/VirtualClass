//
//  ClassSearchViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import Foundation
import UserSDK

public final class ClassSearchViewModel: ObservableObject {
    
    // MARK: - View Model to View
    
    @Published var searchedCourse = "" {
        didSet {
            if searchedCourse.count > 6 && oldValue.count <= 6 {
                searchedCourse = oldValue
            }
        }
    }
    @Published var searchResult: [SearchedCourse] = []
    @Published var showError = false
    
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
        reloadDataSubject
            .compactMap { [weak self] courseIdent in
                self?.findPossibleToEnrollCoursesUseCase.allAvailable
            }
            .map { courses in
                courses.map {
                    SearchedCourse(
                        ident: $0.ident,
                        name: $0.name,
                        isSelected: false
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.searchResult, on: self)
            .store(in: &bag)
        
        $searchedCourse
            .compactMap { $0.count == .zero ? nil : $0 }
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.global(qos: .background))
            .compactMap { [weak self] courseIdent in
                self?.findPossibleToEnrollCoursesUseCase.find(ident: courseIdent)
            }
            .map { courses in
                courses.map {
                    SearchedCourse(
                        ident: $0.ident,
                        name: $0.name,
                        isSelected: false
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.searchResult, on: self)
            .store(in: &bag)
        
        let addClassesResult = addSelectedTapSubject
            .compactMap { [weak self] _ -> [String]? in
                guard let self = self else { return nil }
                
                return self.searchResult
                    .filter { $0.isSelected }
                    .map(\.ident)
            }
            .compactMap { [weak self] courseIdents -> Result<Void, UserRepositoryError>? in
                guard let self = self else { return nil }

                return self.addCoursesUseCase.add(idents: courseIdents)
            }
            .share()
        
        addClassesResult
            .compactMap(\.success)
            .sink(receiveValue: { [weak self] _ in
                self?.classedAddedSuccessfullySubject.send()
            })
            .store(in: &bag)
        
        addClassesResult
            .compactMap(\.failure)
            .map { _ in true }
            .receive(on: DispatchQueue.main)
            .assign(to: \.showError, on: self)
            .store(in: &bag)
    }
}
