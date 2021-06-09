import Foundation

class ContactInfo: Codable {
    var phoneNumbers: [ContactInfoItem]
    var emails: [ContactInfoItem]
    var urls: [ContactInfoItem]
    var addresses: [ContactInfoItem]
    var birthdays: [ContactInfoItem]
    var dates: [ContactInfoItem]
}

struct ContactInfoItem: Codable {
    var type: String
    var value: String
}
