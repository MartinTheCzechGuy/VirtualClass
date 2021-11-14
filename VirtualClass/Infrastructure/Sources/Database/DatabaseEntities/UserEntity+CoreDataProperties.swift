//
//  UserEntity+CoreDataProperties.swift
//  VirtualClass
//
//  Created by Martin on 11.11.2021.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var id: UUID
    @NSManaged public var email: String
}

extension UserEntity : Identifiable {

}
