//
//  ClassDetailViewModel.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Combine

final class ClassDetailViewModel: ObservableObject {
    
    // MARK: - VM to View
    let selectedClass: Class
    
    // MARK: - VM to Coordinator
    public let goBackTap: AnyPublisher<Void, Never>
    
    // MARK: - Private
    let goBackSubject = PassthroughSubject<Void, Never>()
    
    init(selectedClass: Class) {
        self.selectedClass = selectedClass
        self.goBackTap = goBackSubject.eraseToAnyPublisher()
    }
}
