//
//  SQLDBManager.swift
//  
//
//  Created by Martin on 18.11.2021.
//

import Foundation
import GRDB

protocol SQLDBManaging {
    func databasePool(setup: DatabaseSetup, completion: @escaping (Result<DatabasePool, DatabaseError>) -> Void)
    func removeDatabase(completion: @escaping (Result<Void, DatabaseError>) -> Void)
}

final class SQLDBManager: SQLDBManaging {
    private let fileManager: FileManager = .default
    
    func databasePool(setup: DatabaseSetup, completion: @escaping (Result<DatabasePool, DatabaseError>) -> Void) {
        let dbURL: URL
        let coordinator = NSFileCoordinator()
        var coordinatorError: NSError?
        
        do {
            dbURL = try databaseUrl()
        } catch {
            let establishingDBConnectionError = DatabaseError(cause: .errorEstabilishingDBConnection, underlyingError: error)

            completion(.failure(establishingDBConnectionError))
            return
        }
        
        coordinator.coordinate(writingItemAt: dbURL, options: .forMerging, error: &coordinatorError) { url in
            do {
                let databasePool = try DatabasePool(path: url.path)
                try setup.migrator.migrate(databasePool)
                
                completion(.success(databasePool))
            } catch let dbError as DatabaseError {
                completion(.failure(dbError))
            } catch {
                let establishingDBConnectionError = DatabaseError(cause: .errorEstabilishingDBConnection, underlyingError: error)
                
                completion(.failure(establishingDBConnectionError))
            }
        }
    }
    
    func removeDatabase(completion: @escaping (Result<Void, DatabaseError>) -> Void = { _ in }) {
        do {
            let dbUrl = try databaseUrl()
            if fileManager.fileExists(atPath: dbUrl.path) {
                try fileManager.removeItem(at: dbUrl)
            }
            completion(.success(()))
        } catch let dbError as DatabaseError {
            completion(.failure(dbError))
        } catch {
            let removingDBError = DatabaseError(cause: .errorDeletingDatabase, underlyingError: error)
            
            completion(.failure(removingDBError))
        }
    }
}

private extension SQLDBManager {
    private func databaseUrl() throws -> URL {
        let dbName = "database.sqlite"
        let dbFileIdentifier = "cz.virtual_class.app"
        
        let dbDirectory = try getDBDirectory(
            applicationGroupName: nil
        )
            .appendingPathComponent(sanitizedIdentifier(dbFileIdentifier))
        
        let dbURL = cleanURL(dbDirectory.appendingPathComponent(dbName))
        
        let appDbUrl = try getDBDirectory(
            applicationGroupName: nil
        )
            .appendingPathComponent(dbName)
        
        try createDBDirectoryIfNeeded(
            directory: dbDirectory,
            attributes: [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication]
        )
        
        try move(localDbUrl: appDbUrl, to: dbURL)
        
        return dbURL
    }
    
    private func sanitizedIdentifier(_ identifier: String) -> String {
        identifier.components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: "_")
    }
    
    private func cleanURL(_ url: URL) -> URL {
        var dbPath = url.absoluteString
        if let lastCharacter = dbPath.last, lastCharacter == "/" {
            dbPath.removeLast()
            if let newURL = URL(string: dbPath) {
                return newURL
            }
        }
        
        return url
    }
    
    private func move(localDbUrl: URL, to containerDbUrl: URL) throws {
        guard localDbUrl != containerDbUrl &&
                !fileManager.fileExists(atPath: containerDbUrl.path) &&
                fileManager.fileExists(atPath: localDbUrl.path)
        else {
            return
        }
        
        do {
            try fileManager.moveItem(at: localDbUrl, to: containerDbUrl)
        } catch {
            throw DatabaseError(cause: .errorMovingDB, underlyingError: error)
        }
    }
    
    private func createDBDirectoryIfNeeded(
        directory: URL,
        attributes: [FileAttributeKey: Any]
    ) throws {
        guard !fileManager.fileExists(atPath: directory.path) else { return }
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: attributes)
    }
    
    private func getDBDirectory(applicationGroupName: String?) throws -> URL {
        let baseURL: URL
        
        if let applicationGroupName = applicationGroupName,
           let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: applicationGroupName) {
            baseURL = url
        } else {
            do {
                baseURL = try fileManager.url(
                    for: .applicationSupportDirectory,
                       in: .userDomainMask,
                       appropriateFor: nil,
                       create: true
                )
            } catch {
                throw DatabaseError(cause: .errorAccessingDBDirectory, underlyingError: error)
            }
        }
        
        return baseURL.appendingPathComponent("databases")
    }
}
