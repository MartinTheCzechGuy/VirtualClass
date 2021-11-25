//
//  SQLDBSetup+populateMockData.swift
//  
//
//  Created by Martin on 21.11.2021.
//

import Foundation
import GRDB

extension SQLDBSetup {
    static func populateMockData(database db: Database) throws -> Void {
        let classRoom1 = try ClassRoomEntity(id: UUID(), name: "1TR101").inserted(db)
        let classRoom2 = try ClassRoomEntity(id: UUID(), name: "1TR102").inserted(db)
        let classRoom3 = try ClassRoomEntity(id: UUID(), name: "1TR103").inserted(db)
        let classRoom4 = try ClassRoomEntity(id: UUID(), name: "1TR104").inserted(db)
        let classRoom5 = try ClassRoomEntity(id: UUID(), name: "1TR105").inserted(db)
        let classRoom6 = try ClassRoomEntity(id: UUID(), name: "2TR101").inserted(db)
        let classRoom7 = try ClassRoomEntity(id: UUID(), name: "1JH301").inserted(db)
        let classRoom8 = try ClassRoomEntity(id: UUID(), name: "1JH302").inserted(db)
        let classRoom9 = try ClassRoomEntity(id: UUID(), name: "1JH303").inserted(db)

        let facultyOfInformatics = try FacultyEntity(id: UUID(), name: .facultyOfInformatics).inserted(db)
        let facultyOfEconomics = try FacultyEntity(id: UUID(),name: .facultyOfEconomics).inserted(db)
        let facultyOfAccounting = try FacultyEntity(id: UUID(), name: .facultyOfAccounting).inserted(db)
        let facultyOfManagement = try FacultyEntity(id: UUID(), name: .facultyOfManagement).inserted(db)
        
        let math1 = try CourseEntity(
            ident: "1INF101",
            name: "Mathematics I.",
            description: "This course provides students with understanding of basic mathematical concepts.",
            credits: 4,
            lectures: [
                Date(),
                Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            ],
            facultyId: facultyOfInformatics.id,
            classRoomId: classRoom1.id
        )
            .inserted(db)
        
        let math2 = try CourseEntity(
            ident: "1INF201",
            name: "Mathematics II.",
            description: "This course provides students with understanding of intermediate mathematical concepts.",
            credits: 6,
            lectures: [
                Date(),
                Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            ],
            facultyId: facultyOfInformatics.id,
            classRoomId: classRoom5.id
        )
            .inserted(db)
        
        let insuranceMath = try CourseEntity(
            ident: "2AC206",
            name: "Insurance Mathematics",
            description: "This course introduces basic terms, principles and calculations used in insurance mathematics.",
            credits: 6,
            lectures: [
                Date(),
                Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            ],
            facultyId: facultyOfAccounting.id,
            classRoomId: classRoom2.id
        )
            .inserted(db)
        
        let businessAndLaw = try CourseEntity(
            ident: "1EN204",
            name: "Business and law",
            description: "This course provides students with knowledge of legal relations arising from enterpreneurial activities.",
            credits: 5,
            lectures: [
                Date(),
                Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            ],
            facultyId: facultyOfEconomics.id,
            classRoomId: classRoom7.id
        )
            .inserted(db)
        
        let english1 = try CourseEntity(
            ident: "1EN201",
            name: "English Intermediate I.",
            description: "This course is the first part of a serie of courses aming to improve students language skills and prepare them for the Cambridge exams.",
            credits: 3,
            lectures: [
                Date(),
                Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            ],
            facultyId: facultyOfEconomics.id,
            classRoomId: classRoom9.id
        )
            .inserted(db)
        
        let english2 = try CourseEntity(
            ident: "1EN202",
            name: "English Intermediate II.",
            description: "This course is the second part of a serie of courses aming to improve students language skills and prepare them for the Cambridge exams.",
            credits: 3,
            lectures: [
                Date(),
                Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            ],
            facultyId: facultyOfEconomics.id,
            classRoomId: classRoom9.id
        )
            .inserted(db)
        
        let projectManagement = try CourseEntity(
            ident: "1MG109",
            name: "Project Management",
            description: "This course provides students with basic knowledge and skills from the project management field. The main part of this course is a case study illustrating daily operations on a project.",
            credits: 3,
            lectures: [
                Date(),
                Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            ],
            facultyId: facultyOfManagement.id,
            classRoomId: classRoom3.id
        )
            .inserted(db)
        
        let swiftProgramming = try CourseEntity(
            ident: "2INF401",
            name: "Programming in Swift language",
            description: "This course provides basic knowledge of programming in the Swift language. Part of the focus is on iOS platform.",
            credits: 6,
            lectures: [
                Date(),
                Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            ],
            facultyId: facultyOfInformatics.id,
            classRoomId: classRoom4.id
        )
            .inserted(db)
        
        let johnTeacher = try TeacherEntity(id: UUID(), name: "John Lennon").inserted(db)
        let peteTeacher = try TeacherEntity(id: UUID(), name: "Pete Best").inserted(db)
        let chasTeacher = try TeacherEntity(id: UUID(), name: "Chas Newby").inserted(db)
        let paulTeacher = try TeacherEntity(id: UUID(), name: "Paul McCartney").inserted(db)
        let ringoTeacher = try TeacherEntity(id: UUID(), name: "Ringo Star").inserted(db)
        let victoriaTeacher = try TeacherEntity(id: UUID(), name: "Victoria Beckham").inserted(db)
        let melanieBTeacher = try TeacherEntity(id: UUID(), name: "Melanie Brown").inserted(db)
        let melanieCTeacher = try TeacherEntity(id: UUID(), name: "Melanie Chisholm").inserted(db)
        
        try CoursesTaughtBy(id: UUID(), courseIdent: swiftProgramming.ident, teacherId: johnTeacher.id).insert(db)
        try CoursesTaughtBy(id: UUID(), courseIdent: projectManagement.ident, teacherId: melanieBTeacher.id).insert(db)
        try CoursesTaughtBy(id: UUID(), courseIdent: english2.ident, teacherId: peteTeacher.id).insert(db)
        try CoursesTaughtBy(id: UUID(), courseIdent: english1.ident, teacherId: chasTeacher.id).insert(db)
        try CoursesTaughtBy(id: UUID(), courseIdent: businessAndLaw.ident, teacherId: paulTeacher.id).insert(db)
        try CoursesTaughtBy(id: UUID(), courseIdent: insuranceMath.ident, teacherId: ringoTeacher.id).insert(db)
        try CoursesTaughtBy(id: UUID(), courseIdent: math2.ident, teacherId: victoriaTeacher.id).insert(db)
        try CoursesTaughtBy(id: UUID(), courseIdent: math1.ident, teacherId: melanieCTeacher.id).insert(db)
        
        let joanStudent = try StudentEntity(id: UUID(), name: "Joan Louisa McLean", email: "joan@student.cz").inserted(db)
        let jeanStudent = try StudentEntity(id: UUID(), name: "Jean Valentine", email: "jean@student.cz").inserted(db)
        let alanStudent = try StudentEntity(id: UUID(), name: "Alan Turing", email: "alan@student.cz").inserted(db)
        let derekStudent = try StudentEntity(id: UUID(), name: "Derek Taunt", email: "derek@student.cz").inserted(db)
        let raplhStudent = try StudentEntity(id: UUID(), name: "Raplh Tester", email: "ralph@student.cz").inserted(db)
        let graftonStudent = try StudentEntity(id: UUID(), name: "Grafton Melville Richards", email: "grafton@student.cz").inserted(db)
        let dillyStudent = try StudentEntity(id: UUID(), name: "Dilly Knox", email: "dilly@student.cz").inserted(db)
        let royStudent = try StudentEntity(id: UUID(), name: "Roy Jenkins", email: "roy@student.cz").inserted(db)
        
        try CoursesStudiedBy(id: UUID(), courseIdent: swiftProgramming.ident, studentId: joanStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: english1.ident, studentId: joanStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: businessAndLaw.ident, studentId: joanStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: english2.ident, studentId: jeanStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: swiftProgramming.ident, studentId: jeanStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: swiftProgramming.ident, studentId: alanStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: math2.ident, studentId: alanStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: english2.ident, studentId: alanStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: projectManagement.ident, studentId: derekStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: swiftProgramming.ident, studentId: derekStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: english1.ident, studentId: derekStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: english1.ident, studentId: raplhStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: math1.ident, studentId: raplhStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: projectManagement.ident, studentId: raplhStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: projectManagement.ident, studentId: graftonStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: businessAndLaw.ident, studentId: graftonStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: math1.ident, studentId: graftonStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: swiftProgramming.ident, studentId: dillyStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: math2.ident, studentId: royStudent.id).insert(db)
        try CoursesStudiedBy(id: UUID(), courseIdent: english2.ident, studentId: royStudent.id).insert(db)
        
        try CoursesCompletedBy(id: UUID(), courseIdent: math2.ident, studentId: joanStudent.id).insert(db)
        try CoursesCompletedBy(id: UUID(), courseIdent: math1.ident, studentId: jeanStudent.id).insert(db)
        try CoursesCompletedBy(id: UUID(), courseIdent: english1.ident, studentId: alanStudent.id).insert(db)
        try CoursesCompletedBy(id: UUID(), courseIdent: math1.ident, studentId: derekStudent.id).insert(db)
        try CoursesCompletedBy(id: UUID(), courseIdent: english1.ident, studentId: raplhStudent.id).insert(db)
        try CoursesCompletedBy(id: UUID(), courseIdent: english1.ident, studentId: graftonStudent.id).insert(db)
        try CoursesCompletedBy(id: UUID(), courseIdent: math1.ident, studentId: dillyStudent.id).insert(db)
        try CoursesCompletedBy(id: UUID(), courseIdent: math1.ident, studentId: royStudent.id).insert(db)
    }
}
