//
//  SQLDBSetup.swift
//  
//
//  Created by Martin on 21.11.2021.
//

import GRDB

protocol DatabaseSetup {
    var migrator: DatabaseMigrator { get }
    
    func registerMigration(migrator: inout DatabaseMigrator)
}

struct SQLDBSetup: DatabaseSetup {
    private(set) var migrator: DatabaseMigrator
    
    init() {
        self.migrator = DatabaseMigrator()
        
        registerMigration(migrator: &self.migrator)
    }
    
    func registerMigration(migrator: inout DatabaseMigrator) {
        migrator.registerMigration("1.0.0") { db in
            try SQLDBSetup.databaMigration(database: db)
            try SQLDBSetup.populateMockData(database: db)
        }
    }
}
