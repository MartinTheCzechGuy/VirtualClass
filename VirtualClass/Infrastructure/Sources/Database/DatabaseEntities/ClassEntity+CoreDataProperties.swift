//
//  ClassEntity+CoreDataProperties.swift
//  VirtualClass
//
//  Created by Martin on 11.11.2021.
//
//

import Foundation
import CoreData


extension ClassEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClassEntity> {
        return NSFetchRequest<ClassEntity>(entityName: "ClassEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
}

extension ClassEntity : Identifiable {

}
