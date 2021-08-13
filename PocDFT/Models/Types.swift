//
//  Types.swift
//  PocDFT
//
//  Created by ashlee.muscroft on 11/08/2021.
//

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

struct PublicationDelivery: Decodable {
    let dataObjects: DataObjects
}

struct DataObjects: Decodable {
    let compositeFrame: [CompositeFrame]
    
}

struct CompositeFrame: Decodable {
    let operatorName: String
    let description: String
    let frames: Frames
    
    enum CodingKeys: String, CodingKey {
        case operatorName = "Name"
        case description
        case frames
    }
}

struct Frames: Decodable {
    let items: [Frame]
}

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
        case fareFrame
        case resourceFrame
    }
}

extension Frame.Content: Equatable {}

extension Frame: Decodable {
    enum CodingKeys: String, XMLChoiceCodingKey {
        case fare = "FareFrames", resource = "ResourceFrame"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let singContainer = try decoder.singleValueContainer()
        do {
            self = .fare(try container.decode(Content.self, forKey: .fare))
        } catch {
            self =
               .resource(try container.decode(Content.self, forKey: .resource))
        }
    }
}

// MARK: - PeriodGeoZoneTicket
struct PeriodGeoZoneTicket: Decodable{
//    let zoneName: String
//    let operatorName: String
    let fareZones: [FareZone]
    var products: [Product]
    let dataObjects: [CompositeFrame]
    
    private enum CodingKeys: String, CodingKey {
        case compositeFrame
        case dataObjects
        case products
        case zones
    }
    
    private enum FrameKeys: String, CodingKey {
        case frames
    }
    
    private enum TariffKeys: String, CodingKey {
        case tariffs
    }
    
    private enum FareZoneKeys: String, CodingKey {
        case fareZones
    }
    // from decoder defined inorder to skip to the nested element to act as the first element.
    init(from decoder: Decoder) throws {
        let dataObject = try decoder.container(keyedBy: CodingKeys.self)
        // capture the child element dataObjects to extract data we want from the XML
        let values = try dataObject.nestedContainer(keyedBy: CodingKeys.self, forKey: .dataObjects)
        
        //MARK: CompositeFrame
        let framesContainer = try values.nestedContainer(keyedBy: FrameKeys.self, forKey: .compositeFrame)
        var frames = [CompositeFrame]()
        frames.append(try framesContainer.decode(CompositeFrame.self, forKey: .frames))
        dataObjects = frames
//        operatorName = try values.decode(String.self, forKey: .name)
//        zoneName = try values.decode(String.self, forKey: .zoneName)
//
        //MARK: tariffs
        let tariffsContainer = try dataObject.nestedContainer(keyedBy: TariffKeys.self, forKey: .products)
        var tariffs = [Product]()
        tariffs.append(try tariffsContainer.decode(Product.self, forKey: .tariffs))
        products = tariffs
        
        //MARK: farezones
        let fareZoneContainer = try dataObject.nestedContainer(keyedBy: FareZoneKeys.self, forKey: .zones)
        var fares = [FareZone]()
        fares.append(try fareZoneContainer.decode(FareZone.self, forKey: .fareZones))
        fareZones = fares
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

//Organisations.Operator
struct Operator: Decodable {
    let nocCode: String //PublicCode
    let name: String
    let shortName: String
    let phone: String //ContactDetails.Phone
    let website: String //ContactDetails.URL
    let email: String //CustomerServiceContactDetails.Email
    let address: String //Address.Street
}

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

