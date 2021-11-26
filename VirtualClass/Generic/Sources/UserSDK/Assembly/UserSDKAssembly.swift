//
//  UserSDKAssembly.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Swinject
import SwinjectAutoregistration
import Database

public class UserSDKAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
    
        // MARK: - User Auth
        
        container.autoregister(UserAuthRepositoryType.self, initializer: UserAuthRepository.init)
            .inObjectScope(.container)
        
        container.autoregister(CheckValidPasswordUseCaseType.self, initializer: CheckValidPasswordUseCase.init)
        container.autoregister(CheckValidEmailUseCaseType.self, initializer: CheckValidEmailUseCase.init)
        container.autoregister(HandleLoginUseCaseType.self, initializer: HandleLoginUseCase.init)
        container.autoregister(HandleRegistrationUseCaseType.self, initializer: HandleRegistrationUseCase.init)
        container.autoregister(HandleLogOutUseCaseType.self, initializer: HandleLogOutUseCase.init)
        container.autoregister(IsEmailUsedUseCaseType.self, initializer: IsEmailUsedUseCase.init)
        container.autoregister(IsUserLoggedInUseCaseType.self, initializer: IsUserLoggedInUseCase.init)

        // MARK: User Profile
        
        container.autoregister(StudentRepositoryType.self, initializer: StudentRepository.init)
            .inObjectScope(.container)
        
        container.autoregister(UpdateStudentProfileUseCaseType.self, initializer: UpdateStudentProfileUseCase.init)
        container.autoregister(CreateStudentProfileUseCaseType.self, initializer: CreateStudentProfileUseCase.init)
        container.autoregister(GetStudentProfileUseCaseType.self, initializer: GetStudentProfileUseCase.init)
        container.autoregister(GetLoggedInUserUseCaseType.self, initializer: GetLoggedInUserUseCase.init)
        container.autoregister(GetActiveCoursesUseCaseType.self, initializer: GetActiveCoursesUseCase.init)
        
        // MARK: - Courses
        
        container.autoregister(GetActiveCoursesForLoggedInUserUseCaseType.self, initializer: GetActiveCoursesForLoggedInUserUseCase.init)
        container.autoregister(RemoveCourseFromStudiedUseCaseType.self, initializer: RemoveCourseFromStudiedUseCase.init)
        container.autoregister(MarkCourseCompleteUseCaseType.self, initializer: MarkCourseCompleteUseCase.init)
        container.autoregister(GetCoursesToEnrollUseCaseType.self, initializer: GetCoursesToEnrollUseCase.init)
        container.autoregister(AddToUserActiveCoursesUseCaseType.self, initializer: AddToUserActiveCoursesUseCase.init)
        container.autoregister(GetLecturesUseCaseType.self, initializer: GetLecturesUseCase.init)
        container.autoregister(GetCompletedCoursesForLoggedInUserUseCaseType.self, initializer: GetCompletedCoursesForLoggedInUserUseCase.init)
        container.autoregister(GetCompletedCoursesUseCaseType.self, initializer: GetCompletedCoursesUseCase.init)
    }
}
