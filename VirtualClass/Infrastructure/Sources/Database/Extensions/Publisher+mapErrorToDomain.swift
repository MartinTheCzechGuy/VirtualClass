//
//  Publisher+mapErrorToDomain.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Combine

extension Publisher where Failure == ExternalDatabaseError {
    func mapErrorToDomain() -> AnyPublisher<Output, DatabaseError> {
        mapError { externalError in
            switch externalError.cause {
            case .fetchError:
                return .init(cause: .fetchError, underlyingError: externalError)
            case .nilWhenFetch:
                return .init(cause: .objectNotFound, underlyingError: externalError)
            case .objectExistsWhenCreate:
                return .init(cause: .entitiesCollision, underlyingError: externalError)
            case .saveError:
                return .init(cause: .saveError, underlyingError: externalError)
            case .deleteError:
                return .init(cause: .deleteError, underlyingError: externalError)
            case .observeError:
                return .init(cause: .observeError, underlyingError: externalError)
            }
        }
        .eraseToAnyPublisher()
    }
}
