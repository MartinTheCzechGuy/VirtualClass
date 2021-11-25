//
//  DatabaseQueryable.swift
//  
//
//  Created by Martin on 18.11.2021.
//

import Foundation
import GRDB

protocol DatabaseQueryable: Codable, Identifiable, FetchableRecord, PersistableRecord {}
