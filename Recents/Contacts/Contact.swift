//
//  Contact.swift
//  Recents
//
//  Created by Dimitar Dinev on 4.06.21.
//

import Foundation

struct Contact: Codable {
    var firstName: String
    var lastName: String?
    var companyName: String?

    static let otherData = """
    {
        "phoneNumbers": [
            {
                "type": "mobile",
                "number": "12312311"
            },
            {
                "type": "home",
                "number": "12312311"
            },
            {
                "type": "work",
                "number": "12312311"
            },
            {
                "type": "iPhone",
                "number": "12312311",
            }
        ],
        "emails": [
            {
                "type": "home",
                "email": "asdasda@dasda.efg"
            },
            {
                "type": "work",
                "email": "ksjdnfs@gh.vf"
            }
        ],
        "urls": [
            {
                "type": "home",
                "url": "asdad.com"
            },
            {
                "type": "work",
                "url": "pafd-asd.bg"
            }
        ],
        "addresses": [
            {
                "type": "home",
                "address": "burgas"
            },
            {
                "type": "work",
                "address": "sofia"
            }
        ],
        "birthdays": [
           {
               "type": "birthday",
               "date": "22.12.1997"
           }
        ],
        "dates": [
           {
               "type": "anniversary",
               "date": "22.12.1997"
           }
        ]
    }
    """
}

struct ContactInfo: Codable {
    var phoneNumbers: [PhoneNumber]
    var emails: [Email]
    var urls: [URl]
    var addresses: [Address]
    var birthdays: [Datee]
    var dates: [Datee]
}

struct PhoneNumber: Codable {
    var type: String
    var number: String
}

struct Email: Codable {
    var type: String
    var email: String
}

struct URl: Codable {
    var type: String
    var url: String
}

struct Address: Codable {
    var type: String
    var address: String
}

struct Datee: Codable {
    var type: String
    var date: String
}
