//
//  RecentCall+CoreDataProperties.swift
//  Recents
//
//  Created by Dimitar Dinev on 18.06.21.
//
//

import Foundation
import CoreData


extension RecentCall {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentCall> {
        return NSFetchRequest<RecentCall>(entityName: "RecentCall")
    }

    @NSManaged public var callType: String?
    @NSManaged public var contactName: String?
    @NSManaged public var date: Date?
    @NSManaged public var isMissed: Bool
    @NSManaged public var isOutgoing: Bool
    @NSManaged public var contacts: Contact?

}

extension RecentCall : Identifiable {

}
