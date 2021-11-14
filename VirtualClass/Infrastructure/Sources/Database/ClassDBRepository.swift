//
//  ClassDBRepositoryType.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Combine
import Foundation

var DBVole: [DomainUserModel] = [
    DomainUserModel(
        id: UUID(),
        name: "Vašek",
        email: "vasek.kral@seznam.cz",
        classes: [
            .init(id: UUID(), name: "Matematika"),
            .init(id: UUID(), name: "Angličtina")
        ]
    ),
    DomainUserModel(
        id: UUID(),
        name: "Jarda",
        email: "jarda.petarda@google.com",
        classes: [
            .init(id: UUID(), name: "Matematika"),
            .init(id: UUID(), name: "Právo")
        ]
    ),
    DomainUserModel(
        id: UUID(),
        name: "Adam Lančaric",
        email: "adam@google.com",
        classes: [
            .init(id: UUID(), name: "Matematika"),
            .init(id: UUID(), name: "Právo")
        ]
    ),
]

//public protocol ClassDBRepositoryType {
//    func create(domainModel: DomainClassModel) -> Result<Void, DatabaseError>
//    func createOrUpdate(domainModel: DomainClassModel) -> Result<Void, DatabaseError>
//    func load(withID id: UUID) -> Result<DomainClassModel?, DatabaseError>
//    func loadAll() -> Result<[DomainClassModel], DatabaseError>
//    func update(_ domainModel: DomainClassModel) -> Result<Void, DatabaseError>
//    func delete(withID id: UUID) -> Result<Void, DatabaseError>
//
//    func observe(withID id: UUID) -> AnyPublisher<DomainClassModel?, DatabaseError>
//    func observeAll() -> AnyPublisher<[DomainClassModel], DatabaseError>
//}
//
//final class ClassDBRepository: ClassDBRepositoryType {
//    func create(domainModel: DomainClassModel) -> Result<Void, DatabaseError> {
////        repository.create(domainModel)
////            .mapErrorToDomain()
//        
//        DBVole.append(domainModel)
//        
//        return .success(())
//    }
//    
//    func createOrUpdate(domainModel: DomainClassModel) -> Result<Void, DatabaseError> {
////        repository.createOrUpdate(domainModel)
////            .mapErrorToDomain()
//        
//        var newUsers = [DomainClassModel]()
//        
//        DBVole.forEach {
//            if $0.id != domainModel.id {
//                newUsers.append($0)
//            }
//        }
//        
//        newUsers.append(domainModel)
//        
//        DBVole = newUsers
//        
//        return .success(())
//    }
//    
//    func load(withID id: UUID) -> Result<DomainClassModel?, DatabaseError> {
////        repository.load(byID: id)
////            .mapErrorToDomain()
//        
//        return .success(DBVole.first(where: { $0.id == id }))
//    }
//    
//    func loadAll() -> Result<[DomainClassModel], DatabaseError> {
////        repository.load()
////            .mapErrorToDomain()
//        
//        .success(DBVole)
//    }
//    
//    func update(_ domainModel: DomainClassModel) -> Result<Void, DatabaseError> {
////        repository.update(domainModel)
////            .mapErrorToDomain()
//        
//        var newUsers = [DomainClassModel]()
//        
//        DBVole.forEach {
//            if $0.id != domainModel.id {
//                newUsers.append($0)
//            }
//        }
//        
//        newUsers.append(domainModel)
//        
//        DBVole = newUsers
//        
//        return .success(())
//    }
//    
//    func delete(withID id: UUID) -> Result<Void, DatabaseError> {
//        var newUsers = [DomainClassModel]()
//        
//        DBVole.forEach {
//            if $0.id != id {
//                newUsers.append($0)
//            }
//        }
//        
//        DBVole = newUsers
//                
//        return .success(())
//    }
//    
//    func observe(withID id: UUID) -> AnyPublisher<DomainClassModel?, DatabaseError> {
//        repository.observe(byID: id)
//            .mapErrorToDomain()
//    }
//    
//    func observeAll() -> AnyPublisher<[DomainClassModel], DatabaseError> {
//        repository.observe()
//            .mapErrorToDomain()
//    }
//}
