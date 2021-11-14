//
//  ClassSearchViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import Foundation

public final class ClassSearchViewModel: ObservableObject {
    
    // MARK: - View Model to View
    
    @Published var className = ""
    @Published var searchResult: [SearchedClass] = [
        .init(name: "tada", ident: "ident", description: "", nextClass: Date(), room: "", faculty: "", currentlyStudied: false, isSelected: false),
        .init(name: "tamtada", ident: "ident", description: "", nextClass: Date(), room: "", faculty: "", currentlyStudied: false, isSelected: true)
    ]
    @Published var showError = false
    
    // MARK: - View to View Model
    
    let goBackTapSubject = PassthroughSubject<Void, Never>()
    let addSelectedTapSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - View Model to Coordinator
    
    public let goBackTap: AnyPublisher<Void, Never>
    public let classedAddedSuccessfully: AnyPublisher<Void, Never>
    
    // MARK: - Private
    
    private let classedAddedSuccessfullySubject = PassthroughSubject<Void, Never>()
    private var bag: Set<AnyCancellable> = []
    
    public init() {
        self.goBackTap = goBackTapSubject.eraseToAnyPublisher()
        self.classedAddedSuccessfully = classedAddedSuccessfullySubject.eraseToAnyPublisher()
        
        let addClassesResult = addSelectedTapSubject
            .compactMap { [weak self] _ -> [SearchedClass]? in
                guard let self = self else { return nil }
                
                return self.searchResult.filter { $0.isSelected }
            }
            .compactMap { [weak self] selectedClasses -> Result<Void, Error>? in
                guard let self = self else { return nil }

                #warning("TODO - uloz zmeny")
                return .success(())
            }
            .share()
        
        addClassesResult
            .compactMap(\.success)
            .sink(receiveValue: { [weak self] _ in
                self?.classedAddedSuccessfullySubject.send()
            })
            .store(in: &bag)
    }
}
