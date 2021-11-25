//
//  Faculty.swift
//  
//
//  Created by Martin on 21.11.2021.
//

import Foundation

public enum Faculty {
    case facultyOfEconomics
    case facultyOfInformatics
    case facultyOfAccounting
    case facultyOfManagement
}

extension Faculty: Equatable {}

extension Faculty: Hashable {}
