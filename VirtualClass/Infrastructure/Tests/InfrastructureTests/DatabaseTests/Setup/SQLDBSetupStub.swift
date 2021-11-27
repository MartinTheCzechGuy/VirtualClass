//
//  SQLDBSetupStub.swift
//  
//
//  Created by Martin on 27.11.2021.
//

import struct GRDB.DatabaseMigrator

@testable import Database

struct SQLDBSetupStub: DatabaseSetup {
    private(set) var migrator: DatabaseMigrator
    
    init() {
        self.migrator = DatabaseMigrator()
        
        registerMigration(migrator: &self.migrator)
    }
    
    func registerMigration(migrator: inout DatabaseMigrator) {
        migrator.registerMigration("1.0.0") { db in
            try SQLDBSetup.databaMigration(database: db)
        }
    }
}
