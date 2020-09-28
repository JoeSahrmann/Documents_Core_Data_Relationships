//
//  Document+CoreDataClass.swift
//  Documents Core Data Relationships
//
//  Created by Joe Sahrmann on 9/28/20.
//
//

import UIKit
import CoreData

@objc(Document)
public class Document: NSManagedObject {

    //this gets and set the date
    var date: Date?{
        get{
            return rawDate as Date?
        }
        set{
            rawDate = newValue as Date?
        }
    }
    var size: Int64?{
        get{
            return rawSize as Int64?
        }
        set{
            rawSize = newValue as Int64? ?? 0
        }
    }
    //this intializes the class properties
    convenience init?(name: String?, content: String?, size: Int64, date:Date?){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        self.init(entity: Document.entity(), insertInto: context)
        self.name = name
        self.content = content
        self.size = size
        self.date = date
        
    }
}
