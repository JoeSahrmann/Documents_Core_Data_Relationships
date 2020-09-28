//
//  Category+CoreDataClass.swift
//  Documents Core Data Relationships
//
//  Created by Joe Sahrmann on 9/28/20.
//
//

import UIKit
import CoreData

@objc(Category)
public class Category: NSManagedObject {

    var documents: [Document]?{
        return self.rawDocument?.array as? [Document]
    }
    convenience init?(title: String){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        self.init(entity: Category.entity(), insertInto: context)
        self.title = title
    }
}
