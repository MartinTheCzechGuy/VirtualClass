//
//  UserDBRepository.swift
//  
//
//  Created by Martin on 10.11.2021.
//

import Combine
import CoreDatabase
import Foundation

typealias ExternalDatabaseError = CoreDatabase.DatabaseError

public protocol UserDBRepositoryType {
//    init(name: String, bundle: Bundle, inMemory: Bool) throws

    func create(domainModel: DomainUserModel) -> Result<Void, DatabaseError>
    func createOrUpdate(domainModel: DomainUserModel) -> Result<Void, DatabaseError>
    func load(withID id: UUID) -> Result<DomainUserModel?, DatabaseError>
    func load(withEmail email: String) -> Result<DomainUserModel?, DatabaseError>
    func loadAll() -> Result<[DomainUserModel], DatabaseError>
    func update(_ domainModel: DomainUserModel) -> Result<Void, DatabaseError>
    func delete(withID id: UUID) -> Result<Void, DatabaseError>

    func observe(withID id: UUID) -> AnyPublisher<DomainUserModel?, DatabaseError>
    func observeAll() -> AnyPublisher<[DomainUserModel], DatabaseError>
}

//extension UserDBRepositoryType {
//    init(name: String) throws {
//        try self.init(name: name, bundle: .main, inMemory: false)
//    }
//}

final class UserDBRepository: UserDBRepositoryType {
    private let repository: DatabaseRepository<UserEntity, DomainUserModel>
    
//    init(name: String, bundle: Bundle = .main, inMemory: Bool = false) throws {
//        
//        //        guard let mom = NSManagedObjectModel.mergedModel(from: [bundle]) else {
//        //            fatalError("Failed to create mom")
//        //        }
//        //        super.init(name: name, managedObjectModel: mom)
//        //        configureDefaults(inMemory)
//        
//        guard let dataModelURL = Bundle.module.url(forResource: "DataModel", withExtension: "momd") else {
//            throw DatabaseError(cause: .errorLoadingDataModel(modelName: "DataModel"), underlyingError: nil)
//        }
//        
//        let provider = DatabaseProvider.live(onURL: URL(string: "www.seznam.cz")!, containerName: dataModelURL.absoluteString)
//        let databaseClient = DatabaseClient(context: provider.context)
//        repository = .init(
//            databaseClient: databaseClient,
//            databaseModelConverter: DatabaseModelConverter.live,
//            domainModelConverter: DomainModelConverter.live
//        )
//    }
    
    
    
    init() {
        let provider = DatabaseProvider.live(onURL: URL(string: "www.seznam.cz")!, containerName: "DataModel")
        let databaseClient = DatabaseClient(context: provider.context)
        repository = .init(
            databaseClient: databaseClient,
            databaseModelConverter: DatabaseModelConverter.live,
            domainModelConverter: DomainModelConverter.live
        )
    }
    
    func create(domainModel: DomainUserModel) -> Result<Void, DatabaseError> {
//        repository.create(domainModel)
//            .mapErrorToDomain()
        
        DBVole.append(domainModel)
        
        return .success(())
    }
    
    func createOrUpdate(domainModel: DomainUserModel) -> Result<Void, DatabaseError> {
//        repository.createOrUpdate(domainModel)
//            .mapErrorToDomain()
        
        var newUsers = [DomainUserModel]()
        
        DBVole.forEach {
            if $0.id != domainModel.id {
                newUsers.append($0)
            }
        }
        
        newUsers.append(domainModel)
        
        DBVole = newUsers
        
        return .success(())
    }
    
    func load(withID id: UUID) -> Result<DomainUserModel?, DatabaseError> {
//        repository.load(byID: id)
//            .mapErrorToDomain()
        
        return .success(DBVole.first(where: { $0.id == id }))
    }
    
    func load(withEmail email: String) -> Result<DomainUserModel?, DatabaseError> {
        return .success(DBVole.first(where: { $0.email == email }))
    }
    
    func loadAll() -> Result<[DomainUserModel], DatabaseError> {
//        repository.load()
//            .mapErrorToDomain()
        
        .success(DBVole)
    }
    
    func update(_ domainModel: DomainUserModel) -> Result<Void, DatabaseError> {
//        repository.update(domainModel)
//            .mapErrorToDomain()
        
        var newUsers = [DomainUserModel]()
        
        DBVole.forEach {
            if $0.id != domainModel.id {
                newUsers.append($0)
            }
        }
        
        newUsers.append(domainModel)
        
        DBVole = newUsers
        
        return .success(())
    }
    
    func delete(withID id: UUID) -> Result<Void, DatabaseError> {
        var newUsers = [DomainUserModel]()
        
        DBVole.forEach {
            if $0.id != id {
                newUsers.append($0)
            }
        }
        
        DBVole = newUsers
                
        return .success(())
    }
    
    func observe(withID id: UUID) -> AnyPublisher<DomainUserModel?, DatabaseError> {
        repository.observe(byID: id)
            .mapErrorToDomain()
    }
    
    func observeAll() -> AnyPublisher<[DomainUserModel], DatabaseError> {
        repository.observe()
            .mapErrorToDomain()
    }
}
