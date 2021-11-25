//
//  SQLDBSetup+migration.swift
//  
//
//  Created by Martin on 21.11.2021.
//

import GRDB

extension SQLDBSetup {
    static func databaMigration(database db: Database) throws -> Void {
        do {
            try db.create(table: DatabaseTable.course) { table in
                table.column(CourseTableRow.ident, .text)
                    .primaryKey(onConflict: .replace, autoincrement: false)
                table.column(CourseTableRow.name, .text).notNull()
                table.column(CourseTableRow.description, .text).notNull()
                table.column(CourseTableRow.credits, .numeric).notNull()
                table.column(CourseTableRow.lectures, .text).notNull()
                table.column(CourseTableRow.facultyId, .text)
                    .notNull()
                    .indexed()
                    .references(DatabaseTable.faculty, column: FacultyTableRow.id)
                table.column(CourseTableRow.classRoomId, .text)
                    .notNull()
                    .indexed()
                    .references(DatabaseTable.classRoom, column: FacultyTableRow.id)
            }
            
            try db.create(table: DatabaseTable.faculty) { table in
                table.column(FacultyTableRow.id, .text)
                    .primaryKey(onConflict: .replace, autoincrement: false)
                table.column(FacultyTableRow.name, .text).notNull()
            }
            
            try db.create(table: DatabaseTable.classRoom) { table in
                table.column(ClassRoomTableRow.id, .text)
                    .primaryKey(onConflict: .replace, autoincrement: false)
                table.column(ClassRoomTableRow.name, .text).notNull()
            }
            
            try db.create(table: DatabaseTable.student) { table in
                table.column(StudentTableRow.id, .text)
                    .primaryKey(onConflict: .replace, autoincrement: false)
                table.column(StudentTableRow.name, .text)
                    .notNull()
                table.column(StudentTableRow.email, .text)
                    .notNull()
                    .unique()
            }
            
            try db.create(table: DatabaseTable.teacher) { table in
                table.column(TeacherTableRow.id, .text)
                    .primaryKey(onConflict: .replace, autoincrement: false)
                table.column(TeacherTableRow.name, .text).notNull()
            }
            
            try db.create(table: DatabaseTable.coursesTaughtBy) { table in
                table.column(CoursesTaughtByTableRow.id, .text)
                    .primaryKey(onConflict: .replace, autoincrement: false)
                table.column(CoursesTaughtByTableRow.teacherId, .text)
                    .notNull()
                    .references(DatabaseTable.teacher, onDelete: .cascade)
                table.column(CoursesTaughtByTableRow.courseId, .text)
                    .notNull()
                    .references(DatabaseTable.course, onDelete: .cascade)
            }
            
            try db.create(table: DatabaseTable.coursesStudiedBy) { table in
                table.column(CoursesStudiedByTableRow.id, .text)
                    .primaryKey(onConflict: .replace, autoincrement: false)
                table.column(CoursesStudiedByTableRow.studentId, .text)
                    .notNull()
                    .references(DatabaseTable.student, onDelete: .cascade)
                table.column(CoursesStudiedByTableRow.courseId, .text)
                    .notNull()
                    .references(DatabaseTable.course, onDelete: .cascade)
            }
            
            try db.create(table: DatabaseTable.coursesCompletedBy) { table in
                table.column(CoursesCompletedByTableRow.id, .text)
                    .primaryKey(onConflict: .replace, autoincrement: false)
                table.column(CoursesCompletedByTableRow.studentId, .text)
                    .notNull()
                    .references(DatabaseTable.student, onDelete: .cascade)
                table.column(CoursesCompletedByTableRow.courseId, .text)
                    .notNull()
                    .references(DatabaseTable.course, onDelete: .cascade)
            }
            
            try populateMockData(database: db)            
        } catch {
            throw DatabaseError(cause: .migrationError, underlyingError: error)
        }
    }
}
