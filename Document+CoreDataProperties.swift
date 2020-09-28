//
//  Document+CoreDataProperties.swift
//  Documents Core Data Relationships
//
//  Created by Joe Sahrmann on 9/28/20.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var name: String?
    @NSManaged public var content: String?
    @NSManaged public var rawSize: Int64
    @NSManaged public var rawDate: Date?
    @NSManaged public var document: Category?

}

extension Document : Identifiable {

}
