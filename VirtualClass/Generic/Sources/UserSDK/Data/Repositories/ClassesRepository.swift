//
//  ClassesRepositoryType.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Foundation

protocol ClassesRepositoryType {
    func classes(on date: Date) -> Result<[Class], UserRepositoryError>
}
