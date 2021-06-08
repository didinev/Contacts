//
//  Contact+CoreDataProperties.swift
//  Recents
//
//  Created by Dimitar Dinev on 7.06.21.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var companyName: String?
    @NSManaged public var otherData: String?

}

extension Contact : Identifiable {

}
