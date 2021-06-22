//
//  Favourite+CoreDataProperties.swift
//  Recents
//
//  Created by Dimitar Dinev on 21.06.21.
//
//

import Foundation
import CoreData


extension Favourite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourite> {
        return NSFetchRequest<Favourite>(entityName: "Favourite")
    }

    @NSManaged public var label: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var contact: Contact?

}

extension Favourite : Identifiable {

}
