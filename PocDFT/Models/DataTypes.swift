//
// Created by ashlee.muscroft on 02/09/2021.
//

import Foundation

// MARK: - Product
struct Product: Identifiable {
    var id,
            productName,
            productPrice,
            productDuration: String?
    var productValidity: Valid?
}

enum ProductPaymentTypes: String {
    case Cash = "Onboard (cash)"
    case Contactless = "Onboard (contactless)"
    case SmartCard = "Online (smart card)"
    case MobileApp = "Mobile App"
    case All = "All Encompassing"
    case OnboardOffer = "onboard sales offer package"
    case MobileOffer = "mobile app offer package"
    case OnlineOffer = "online offer package"
}

// MARK: Fare

struct Fare {
    var id: String = ""
    var name: String = ""
    var zoneDescription: String? = ""
    var passengerDescription: String? = ""
    var ref: String = ""
    var price: Prices?
}

// MARK: extensions
extension Product: Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
        guard let lhValidity = lhs.productValidity,
              let rhValidity = rhs.productValidity else {
            return false
        }
        return lhs.productName == rhs.productName &&
                lhValidity.fromDate == rhValidity.fromDate &&
                lhValidity.toDate == rhValidity.toDate &&
                lhs.productDuration == rhs.productDuration
    }
}