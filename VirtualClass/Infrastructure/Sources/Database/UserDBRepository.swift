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
    init(name: String, bundle: Bundle, inMemory: Bool) throws

    func create(domainModel: DomainUserModel) -> Result<Void, DatabaseError>
    func createOrUpdate(domainModel: DomainUserModel) -> Result<Void, DatabaseError>
    func load(withID id: AnyHashable) -> Result<DomainUserModel?, DatabaseError>
    func loadAll() -> Result<[DomainUserModel], DatabaseError>
    func update(_ domainModel: DomainUserModel) -> Result<Void, DatabaseError>
    func delete(withID id: AnyHashable) -> Result<Void, DatabaseError>

    func observe(withID id: AnyHashable) -> AnyPublisher<DomainUserModel?, DatabaseError>
    func observeAll() -> AnyPublisher<[DomainUserModel], DatabaseError>
}

extension UserDBRepositoryType {
    init(name: String) throws {
        try self.init(name: name, bundle: .main, inMemory: false)
    }
}

final class UserDBRepository: UserDBRepositoryType {
    private let repository: DatabaseRepository<UserEntity, DomainUserModel>
    
    init(name: String, bundle: Bundle = .main, inMemory: Bool = false) throws {
        
        //        guard let mom = NSManagedObjectModel.mergedModel(from: [bundle]) else {
        //            fatalError("Failed to create mom")
        //        }
        //        super.init(name: name, managedObjectModel: mom)
        //        configureDefaults(inMemory)
        
        guard let dataModelURL = Bundle.module.url(forResource: "DataModel", withExtension: "momd") else {
            throw DatabaseError(cause: .errorLoadingDataModel(modelName: "DataModel"), underlyingError: nil)
        }
        
        let provider = DatabaseProvider.live(onURL: URL(string: "www.seznam.cz")!, containerName: dataModelURL.absoluteString)
        let databaseClient = DatabaseClient(context: provider.context)
        repository = .init(
            databaseClient: databaseClient,
            databaseModelConverter: DatabaseModelConverter.live,
            domainModelConverter: DomainModelConverter.live
        )
    }
    
    func create(domainModel: DomainUserModel) -> Result<Void, DatabaseError> {
        repository.create(domainModel)
            .mapErrorToDomain()
    }
    
    func createOrUpdate(domainModel: DomainUserModel) -> Result<Void, DatabaseError> {
        repository.createOrUpdate(domainModel)
            .mapErrorToDomain()
    }
    
    func load(withID id: AnyHashable) -> Result<DomainUserModel?, DatabaseError> {
        repository.load(byID: id)
            .mapErrorToDomain()
    }
    
    func loadAll() -> Result<[DomainUserModel], DatabaseError> {
        repository.load()
            .mapErrorToDomain()
    }
    
    func update(_ domainModel: DomainUserModel) -> Result<Void, DatabaseError> {
        repository.update(domainModel)
            .mapErrorToDomain()
    }
    
    func delete(withID id: AnyHashable) -> Result<Void, DatabaseError> {
        repository.delete(withID: id)
            .mapErrorToDomain()
    }
    
    func observe(withID id: AnyHashable) -> AnyPublisher<DomainUserModel?, DatabaseError> {
        repository.observe(byID: id)
            .mapErrorToDomain()
    }
    
    func observeAll() -> AnyPublisher<[DomainUserModel], DatabaseError> {
        repository.observe()
            .mapErrorToDomain()
    }
}
