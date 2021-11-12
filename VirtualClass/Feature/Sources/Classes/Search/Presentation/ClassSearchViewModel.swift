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
    
    let goBackTap = PassthroughSubject<Void, Never>()
    let addSelectedTap = PassthroughSubject<Void, Never>()
    
    public let navigateToUserAccount: AnyPublisher<Void, Never>
    
    private var bag: Set<AnyCancellable> = []
    
    public init() {
        self.navigateToUserAccount = goBackTap.eraseToAnyPublisher()
        
        addSelectedTap
            .compactMap { [weak self] _ -> [SearchedClass]? in
                guard let self = self else { return nil }
                
                return self.searchResult.filter { $0.isSelected }
            }
            .sink(receiveValue: { selectedClasses in
                print("mam selected \(selectedClasses.count) classes")
            })
            .store(in: &bag)
    }
}
