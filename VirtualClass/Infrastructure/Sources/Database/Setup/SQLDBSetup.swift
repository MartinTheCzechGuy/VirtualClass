//
//  SQLDBSetup.swift
//  
//
//  Created by Martin on 21.11.2021.
//

import GRDB

struct SQLDBSetup {
    var migrator: DatabaseMigrator
    
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
