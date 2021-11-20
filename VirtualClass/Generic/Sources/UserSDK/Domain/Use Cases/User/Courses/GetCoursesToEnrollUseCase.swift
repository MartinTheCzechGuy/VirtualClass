//
//  GetCoursesToEnrollUseCase.swift
//  
//
//  Created by Martin on 20.11.2021.
//

import Foundation

public protocol GetCoursesToEnrollUseCaseType {
    func find(ident: String) -> Set<GenericCourse>
    var allAvailable: Set<GenericCourse> { get }
}

final class GetCoursesToEnrollUseCase {
    private let studentRepository: StudentRepositoryType
    private let getCoursesForLoggedInUserUseCase: GetCoursesForLoggedInUserUseCaseType
    
    init(studentRepository: StudentRepositoryType, getCoursesForLoggedInUserUseCase: GetCoursesForLoggedInUserUseCaseType) {
        self.studentRepository = studentRepository
        self.getCoursesForLoggedInUserUseCase = getCoursesForLoggedInUserUseCase
    }
}

extension GetCoursesToEnrollUseCase: GetCoursesToEnrollUseCaseType {
    func find(ident: String) -> Set<GenericCourse> {
        allAvailable.filter { $0.ident == ident }
    }
    
    var allAvailable: Set<GenericCourse> {
        guard let allActiveCourses = studentRepository.activeCourses().success,
              let studentActiveCourses = getCoursesForLoggedInUserUseCase.courses.success
        else {
            return []
        }
        
        return allActiveCourses.subtracting(studentActiveCourses)
    }
}
