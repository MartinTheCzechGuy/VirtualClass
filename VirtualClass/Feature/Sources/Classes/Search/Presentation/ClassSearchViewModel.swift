//
//  ClassSearchViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import Foundation

public final class ClassSearchViewModel: ObservableObject {
    
    @Published var className = ""
    @Published var searchResult: [SearchedClass] = [
        .init(name: "tada", ident: "ident", description: "", nextClass: Date(), room: "", faculty: "", currentlyStudied: false, isSelected: false),
        .init(name: "tamtada", ident: "ident", description: "", nextClass: Date(), room: "", faculty: "", currentlyStudied: false, isSelected: true)
    ]
    @Published var showError = false
    
    // MARK: - Outputs
    
    let goBackTap = PassthroughSubject<Void, Never>()
    let addSelectedTap = PassthroughSubject<Void, Never>()
    
    // MARK: - Actions
    
    public let navigateToUserAccount: AnyPublisher<Void, Never>
    public let navigateToClassOverview: AnyPublisher<Void, Never>
    
    // MARK: - Private
    
    private let userAccountUpdated = PassthroughSubject<Void, Never>()
    private var bag: Set<AnyCancellable> = []
    
    public init() {
        self.navigateToUserAccount = goBackTap.eraseToAnyPublisher()
        self.navigateToClassOverview = userAccountUpdated.eraseToAnyPublisher()
        
        let addClassesResult = addSelectedTap
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
                self?.userAccountUpdated.send()
            })
            .store(in: &bag)
    }
}
