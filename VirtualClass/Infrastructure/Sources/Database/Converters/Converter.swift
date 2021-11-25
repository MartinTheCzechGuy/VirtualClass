//
//  Converter.swift
//
//
//  Created by Martin on 17.11.2021.
//
//
//import RealmSwift
//
struct Converter<ExternalModel, DomainModel> {
    let mapToEntity: (DomainModel) -> ExternalModel
    let mapToDomain: (ExternalModel) -> DomainModel
}

typealias ClassRoomConverter = Converter<ClassRoomEntity, ClassRoom>

extension ClassRoomConverter {
    static func live() -> ClassRoomConverter {
        ClassRoomConverter(
            mapToEntity: { domain in
                ClassRoomEntity(id: domain.id, name: domain.name)
            },
            mapToDomain: { entity in
                ClassRoom(id: entity.id, name: entity.name)
            }
        )
    }
}

//typealias FacultyConverter = Converter<FacultyEntity, Faculty>
//
//extension FacultyConverter {
//    static func live() -> FacultyConverter {
//        FacultyConverter(
//            mapToEntity: { domain in
//                return nil
//            },
//            mapToDomain: { entity in
//                switch entity.name {
//                case .facultyOfEconomics:
//                    return .facultyOfEconomics
//                case .facultyOfInformatics:
//                    return .facultyOfInformatics
//                case .facultyOfAccounting:
//                    return .facultyOfAccounting
//                case .facultyOfManagement:
//                    return .facultyOfManagement
//                }
//            }
//        )
//    }
//}

typealias TeacherConverter = Converter<TeacherEntity, Teacher>

extension TeacherConverter {
    static func live() -> TeacherConverter {
        TeacherConverter(
            mapToEntity: { domain in
                TeacherEntity(id: domain.id, name: domain.name)
            },
            mapToDomain: { entity in
                Teacher(id: entity.id, name: entity.name)
            }
        )
    }
}

//
//typealias ClassConverter = Converter<ClassEntity, Class>
//
//extension ClassConverter {
//    static func live(
//        studentConverter: StudentConverter,
//        teacherConverter: TeacherConverter,
//        classRoomConverter: ClassRoomConverter,
//        facultyConverter: FacultyConverter
//    )
//    static live = ClassConverter(
//        mapToEntity: { domain in
//            ClassEntity(
//                ident: domain.ident,
//                name: domain.name,
//                email: domain.email,
//                classes: domain.classes,
//                students: domain.students.map(studentConverter),
//                teachers: domain.teacher.map(teacherConverter),,
//                classRoom: classRoomConverter,
//                faculty: facultyConverter
//            )
//        },
//        mapToDomain: { entity in
//            Class(
//                ident: <#T##String#>,
//                name: <#T##String#>,
//                email: <#T##String#>,
//                students: <#T##[Student]#>
//            )
//        }
//    )
//}
//
//typealias StudentConverter = Converter<StudentEntity, Student>
//
//typealias FacultyConverter = Converter<FacultyEntity, Faculty>
//
//typealias TeacherConverter = Converter<TeacherEntity, Teacher>
//
//typealias ClassRoomConverter = Converter<ClassRoomEntity, ClassRoom>
//
//extension ClassRoomConverter {
//    static func live() -> ClassRoomConverter {
//        ClassRoomConverter(
//            mapToEntity: { domain in
//                ClassRoomEntity()
//            },
//            mapToDomain: { entity in
//                ClassRoom(id: entity.id, name: entity.name)
//            }
//        )
//    }
//}
