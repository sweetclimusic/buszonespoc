//
//  Types.swift
//  PocDFT
//
//  Created by ashlee.muscroft on 11/08/2021.
//

import BetterCodable
import Foundation
import XMLCoder
//MARK: base types derieved from open source project, https://github.com/fares-data-build-tool/create-data/blob/develop/shared/matchingJsonTypes.ts

//MARK: Concrete enum types
enum TicketType: String, Decodable {
    case flatFare = "flatFare"
    case period = "period"
    case multiOperator = "multiOperator"
    case schoolService = "schoolService"
    case single = "single"
    case `return` = "return"
}

enum TimeRestrictionDay: String, Decodable {
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
    case sunday = "sunday"
    case bankHoliday = "bankHoliday"
}

enum PaymentMethod: String, Decodable {
    case cash = "cash"
    case contactlessPaymentCard = "contactlessPaymentCard"
    case creditCard = "creditCard"
    case debitCard = "debitCard"
    case directDebit = "directDebit"
    case mobilePhone = "mobilePhone"
}

enum TicketFormat: String, Decodable {
    case mobileApp = "mobileApp"
    case paperTicket = "paperTicket"
    case smartCard = "smartCard"
}

enum PurchaseLocation: String, Decodable {
    case mobileDevice = "mobileDevice"
    case onBoard = "onBoard"
    case online = "online"
}

struct FullTimeRestriction: Decodable {
    let day: TimeRestrictionDay
    let timeBands: [TimeBand]
    
    enum CodingKeys: String, CodingKey {
        case day
        case timeBands
    }
}

// MARK: - TimeRestriction
struct TimeRestriction: Decodable {
    let day: String
    let timeBands: [TimeBand]
}

struct TimeBand: Decodable {
    let startTime: String
    let endTime: String
}

struct TicketPeriod: Decodable {
    let period: TimeBand?
    enum CodingKeys: String, CodingKey {
        case period
    }
}

enum ResourceFrameUnion: Decodable {
    case singleResourceFrame(SingleResourceFrame)
    case resourceFrameElementArray([ResourceFrameElement])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([ResourceFrameElement].self) {
            self = .resourceFrameElementArray(x)
            return
        }
        if let x = try? container.decode(SingleResourceFrame.self) {
            self = .singleResourceFrame(x)
            return
        }
        throw DecodingError.typeMismatch(ResourceFrameUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ResourceFrameUnion"))
    }
}

// MARK: - ResourceFrameElement
struct ResourceFrameElement: Decodable{//}, DynamicNodeDecoding {
    let id: String
    //let value: String
    let name: String
    let organisations: PurpleOrganisations?
    let validBetween: Valid?
    let resourceFrameDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        //case value = ""
        case name = "Name"
        case organisations
        case validBetween = "ValidBetween"
        case resourceFrameDescription = "Description"
    }
    
//    static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
//        switch key {
//            case CodingKeys.id:
//                return .attribute
//            default:
//                return .element
//        }
//    }
}

// MARK: - SingleResourceFrame aka PurpleResourceFrame
struct SingleResourceFrame: Decodable {
    let id, name: String
    let organisations: PurpleOrganisations
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "Name"
        case  organisations
    }
}
// MARK: - PurpleOrganisations
struct PurpleOrganisations: Decodable {
    let generalOrganisation: GeneralOrganisation
    let organisationsOperator: [OperatorElement]?
    
    enum CodingKeys: String, CodingKey {
        case generalOrganisation = "GeneralOrganisation"
        case organisationsOperator = "Operator"
    }
}

// MARK: - GeneralOrganisation
struct GeneralOrganisation: Decodable {
    let id, value, name: String
    let shortName, organisationType, modification, status: String?
    let responsibilitySetRef: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case value = ""
        case name = "Name"
        case shortName = "ShortName"
        case organisationType = "OrganisationType"
        case modification, status, responsibilitySetRef
    }
}

// MARK: - OperatorElement
struct OperatorElement: Decodable {
    let id, publicCode, name, shortName: String
    let validityPeriod: Valid
    let countryRef: CountryRef
    
    enum CodingKeys: String, CodingKey {
        case id
        case publicCode = "PublicCode"
        case name = "Name"
        case shortName = "ShortName"
        case validityPeriod = "ValidityPeriod"
        case countryRef = "CountryRef"
    }
}

// MARK: - CountryRef
struct CountryRef: Codable {
    let ref, refPrincipality: String
}

// MARK: ToDelete
enum Frame {
    struct Content {
        let name: String
        let organisation: [String:String]
        let fareFrame: [String:String]
        let resourceFrame: [String:String]
    }
    case fare(Content)
    case resource(Content)
}

extension Frame.Content: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case organisation
        case fareFrame = "FareFrame"//zoneFareFrame, //
        case resourceFrame = "ResourceFrame"
        //case serviceFrame
    }
}

extension Frame.Content: Equatable {}

extension Frame: Decodable {
    enum CodingKeys: String, XMLChoiceCodingKey {
        case fare = "FareFrames", resource = "ResourceFrame"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self = .fare(try container.decode(Content.self, forKey: .fare))
        } catch {
            self =
               .resource(try container.decode(Content.self, forKey: .resource))
        }
    }
}


struct BaseTicket: Decodable {
    let nocCode: String
    let type: TicketType
    let user: User
    let email: String
    let uuid: String
    let timeRestriction: [FullTimeRestriction]
    let ticketPeriod: TicketPeriod
    enum CodingKeys: String, CodingKey {
     case nocCode,email,uuid
     case user = "UserProfile"
     case timeRestriction = "FareDayType"
     case type,ticketPeriod
    }
}

// Specific ticket types derieved from open source project, https://github.com/fares-data-build-tool/create-data/tree/develop/repos/fdbt-netex-output/src\

struct User: Decodable{
    let passengerType: String
    let ageRangeMin: String?
    let ageRangeMax: String?
    let proofDocuments: [String]
    
    enum CodingKeys: String, CodingKey {
        case passengerType = "Name"
        case ageRangeMin = "MinimumAge"
        case ageRangeMax = "MaximumAge"
        case proofDocuments = "ProofRequired"
    }
}
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let periodGeoZoneTicket = try? newJSONDecoder().decode(PeriodGeoZoneTicket.self, from: jsonData)



// MARK: - Product
struct Product: Decodable {
    let productName, productPrice, productDuration, productValidity: String
    let salesOfferPackages: [SalesOfferPackage]
}

// MARK: - SalesOfferPackage
struct SalesOfferPackage: Decodable {
    let name: String
    let salesOfferPackageDescription: String
    let purchaseLocations: [PurchaseLocation]
    let paymentMethods: [PaymentMethod]
    let ticketFormats: [TicketFormat]
    
    enum CodingKeys: String, CodingKey {
        case name
        case salesOfferPackageDescription = "description"
        case purchaseLocations, paymentMethods, ticketFormats
    }
}

// MARK: Literal types from XML

