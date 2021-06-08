//
//  Contact.swift
//  Recents
//
//  Created by Dimitar Dinev on 4.06.21.
//

import Foundation

//struct Contaact: Codable {
//    var firstName: String
//    var lastName: String?
//    var companyName: String?
//
//    static let otherData = """
//    {
//        "phoneNumbers": [
//            {
//                "type": "mobile",
//                "number": "0889 934 358"
//            },
//            {
//                "type": "home",
//                "number": "0887 432 962"
//            },
//            {
//                "type": "work",
//                "number": "0890 321 416"
//            }
//        ],
//        "emails": [
//            {
//                "type": "home",
//                "email": "sexy_bor4eto@abv.bg"
//            },
//            {
//                "type": "work",
//                "email": "dd@infinno.eu"
//            }
//        ],
//        "urls": [
//            {
//                "type": "home",
//                "url": "home.com"
//            },
//            {
//                "type": "work",
//                "url": "work.bg"
//            }
//        ],
//        "addresses": [
//            {
//                "type": "home",
//                "address": "Sofia"
//            },
//            {
//                "type": "work",
//                "address": "Levunovo"
//            }
//        ],
//        "birthdays": [
//           {
//               "type": "birthday",
//               "date": "27.05.2010"
//           }
//        ],
//        "dates": [
//           {
//               "type": "anniversary",
//               "date": "27.05.2010"
//           }
//        ]
//    }
//    """
//}

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
