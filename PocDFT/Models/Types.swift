//
//  Types.swift
//  PocDFT
//
//  Created by ashlee.muscroft on 17/08/2021.
//

import BetterCodable
import Foundation
import XMLCoder

// MARK: - PeriodGeoZoneTicket
struct PeriodGeoZoneTicket: Decodable {
    let publicationDelivery: PublicationDelivery
    enum CodingKeys: String, CodingKey {
        case publicationDelivery = "PublicationDelivery"
    }
}

struct PublicationDelivery: Decodable {
    let dataObjects: DataObjects?
    enum CodingKeys: String, CodingKey {
        case dataObjects = "dataObjects"
    }
}

struct DataObjects: Decodable {
    var compositeFrame: [CompositeFrame]
    
}

struct CompositeFrame: Decodable {
    let name: String
    let description: String?
    let frames: Frames?
    var validBetween: Valid?
    
    enum CodingKeys: String, CodingKey {
        case description
        case frames = "frames"
        case name
        case validBetween = "validBetween"
    }
}

// MARK: - Frames
/// Within a <frames> element, we will need access to ResourceFrame for org data
/// Farefames hold several key elements.
/// 1) Farefames with fareZones,
/// 2) Farefame with tariffs, fareProducts, and salesOfferPackages
/// 3) Farefame with fareTables
struct Frames: Decodable {
    let resourceFrame: ResourceFrame?
    //var fareFrame: [FareFrame]?
    
//    enum CodingKeys: String, CodingKey {
//        case resourceFrame = "resourceFrame"
//      //  case fareFrame = "fareFrame"
//    }
}

// MARK: - Valid
struct Valid: Decodable {
    private let from,to: String?
    var fromDate: Date? {
        get {
            self.date(from: self.from ?? "")
        }
    }
    var toDate: Date? {
        get {
            self.date(from: self.to ?? "")
        }
    }
    enum CodingKeys: String, CodingKey {
        case from = "fromDate"
        case to = "toDate"
    }
}

struct ResourceFrame: Decodable {
    var busOperators: [TransportOperator]?
    
    private enum CodingKeys: String, CodingKey {
        case organisation = "organisations"
        case busOperators = "operator"
    }
    
    init(from decoder: Decoder) throws {
        var operators: [TransportOperator] = []
        let organisation = try? decoder.container(keyedBy: CodingKeys.self)
        if let values = try? organisation?.nestedContainer(keyedBy: CodingKeys.self, forKey: .organisation) {
            operators.append(try values.decode(TransportOperator.self, forKey: .busOperators))
        }
        self.busOperators = operators
    }
}

fileprivate struct ContactDetails: Decodable {
    let phone: String
    let url: String
}
fileprivate struct CustomerServiceDetails: Decodable {
    let email: String
}

fileprivate struct Address: Decodable {
    let street: String
}

// Organisations.Operator
struct TransportOperator: Decodable {
    let nocCode: String? //PublicCode
    let name: String?
    let shortName: String?
    let tradingName: String?
    private var contactDetails: [ContactDetails]?
    private var customerServiceDetails: [CustomerServiceDetails]?
    private var address: [Address]?
    
    private enum CodingKeys: String, CodingKey {
        case nocCode = "publicCode"
        case name, shortName, tradingName
        //Union
        case contactDetails, address
        case customerServiceDetails = "customerServiceContactDetails"
    }
    
//    init(from decoder: Decoder) throws {
//        let busOperator = try? decoder.container(keyedBy: CodingKeys.self)
//        //Expected values
//        self.name = try busOperator?.decode(String.self, forKey: .name) ?? ""
//        self.nocCode = try busOperator?.decode(String.self, forKey: .nocCode) ?? ""
//        self.shortName = try busOperator?.decode(String.self, forKey: .shortName) ?? ""
//        // Optionals
//        self.tradingName = try busOperator?.decode(String.self, forKey: .tradingName) ?? ""
//
//        if let contactDetails = try? busOperator?.nestedContainer(keyedBy: CodingKeys.self, forKey: .contactDetails) {
//            //MARK: Decode contact details
////            self.phone = try contactDetails.decode(String.self, forKey: .phone)
////            self.url = try contactDetails.decode(String.self, forKey: .url)
//        }
//
//        if let address = try? busOperator?.nestedContainer(keyedBy: CodingKeys.self, forKey: .address) {
//            self.address = try address.decode(String.self, forKey: .address)
//        }
//
//        //MARK: Decode email address
//        if let customerServiceDetails = try? busOperator?.nestedContainer(keyedBy: CodingKeys.self, forKey: .customerServiceDetails) {
//            self.email = try customerServiceDetails.decode(String.self, forKey: .email)
//        }
//    }
}

struct FareFrame: Decodable {
    @LossyArray var fareZones: [FareZone]
    //@LossyArray var tariffs: [Tariffs]
    //@LossyArray var fareTables: [FareTables]
    //@LossyArray var fareProducts: [FareProducts]
    //@LossyArray var salesOfferPackage: [SalesOfferPackage]
    ///Farefames with fareZones,
    /// 2) Farefame with tariffs, fareProducts, and salesOfferPackages
    /// 3) Farefame with fareTables
}

struct FareZone: Decodable {
    let name: String
    let description: String
    let stops: [Stop]
    private enum CodingKeys: String, CodingKey {
        case name, description, stops = "members"
    }
}

struct Stop: Decodable {
    let stopName: String
    let naptanCode: String
    let atcoCode: String
    let localityCode: String
    let localityName: String
    let parentLocalityName: String
    let qualifierName: String?
    let indicator: String?
    let street: String?
}

// MARK: - Extensions
extension Valid {
    func date(from dateString: String = "2019-05-01T00:00:00",
              _ dateFormat: String = "YYYY-MM-DD'T'HH:mm:ss") -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        return date
    }
}

// MARK: Contact detail Helpers
extension TransportOperator {
    func phone() -> String {
        return self.contactDetails?.first?.phone ?? ""
    }
    
    func website() -> String {
        return self.contactDetails?.first?.url ?? ""
    }
    
    func street() -> String {
        return self.address?.first?.street ?? ""
    }
    
    func email() -> String {
        return self.customerServiceDetails?.first?.email ?? ""
    }
}
