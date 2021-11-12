//
//  ClassListViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import Foundation

public final class ClassListViewModel: ObservableObject {
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
    
    let goBackTap = PassthroughSubject<Void, Never>()
    
    public let navigateToUserAccount: AnyPublisher<Void, Never>
    
    public init() {
        self.navigateToUserAccount = goBackTap.eraseToAnyPublisher()
    }
}
