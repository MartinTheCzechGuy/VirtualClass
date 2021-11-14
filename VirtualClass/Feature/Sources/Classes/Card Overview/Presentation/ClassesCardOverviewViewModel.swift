//
//  ClassesCardOverviewViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import Foundation

public final class ClassesCardOverviewViewModel: ObservableObject {
    
    @Published var studiedClasses: [Class] = [
        .init(
            name: "Matematika pro ekonomy",
            ident: "4MT651",
            description: "trololo tralala tralala tralala tralala tralala tralala tralala tralala tralala trololo tralala tralala tralala tralala tralala tralala tralala tralala tralalatrololo tralala tralala tralala tralala tralala tralala tralala tralala tralalatrololo tralala tralala tralala tralala tralala tralala tralala tralala tralalatrololo tralala tralala tralala tralala tralala tralala tralala tralala tralalatrololo tralala tralala tralala tralala tralala tralala tralala tralala tralalatrololo tralala tralala tralala tralala tralala tralala tralala tralala tralala",
            nextClass: Date() - 1000,
            room: "TMB333",
            faculty: "Adamusosove",
            currentlyStudied: true
        ),
        .init(
            name: "Právní systém České republiky",
            ident: "3TR3333",
            description: """
            trelele tralala tralala tralala
                        tralala
            tralala tralala tralala tralala
                                    tralala
            """,
            nextClass: Date() - 1000,
            room: "TMB6666",
            faculty: "Dralanove",
            currentlyStudied: true
        ),
        .init(
            name: "Anglický jazyk pro ekonomy",
            ident: "4MT651",
            description: """
            tralala tralala tralala tralala
                        tralala
            tralala tralala tralala tralala
                                    tralala
            """,
            nextClass: Date() - 1000,
            room: "TMB333",
            faculty: "Ajtaci",
            currentlyStudied: true
        )
    ]
    
    // MARK: - ViewModel to Coordinator
    let classCardTap: AnyPublisher<Class, Never>
    let addClassButtonTap: AnyPublisher<Void, Never>
    
    // MARK: - Private
    let classCardTapSubject = PassthroughSubject<Class, Never>()
    let adddClassSubject = PassthroughSubject<Void, Never>()
    
    public init() {
        self.classCardTap = classCardTapSubject.eraseToAnyPublisher()
        self.addClassButtonTap = adddClassSubject.eraseToAnyPublisher()
    }
}
