//
//  ClassesRepositoryType.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Foundation

protocol ClassesRepositoryType {
    func courses(on date: Date) -> Result<[GenericCourse], StudentRepositoryError>
}
