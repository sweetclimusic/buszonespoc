//
//  Types.swift
//  PocDFT
//
//  Created by ashlee.muscroft on 11/08/2021.
//

import Foundation
//MARK: base types derieved from open source project, https://github.com/fares-data-build-tool/create-data/blob/develop/shared/matchingJsonTypes.ts

//MARK: Concrete enum types
enum TicketType: String, Codable {
    case flatFare = "flatFare"
    case period = "period"
    case multiOperator = "multiOperator"
    case schoolService = "schoolService"
    case single = "single"
    case `return` = "return"
}

enum TimeRestrictionDay: String, Codable {
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
    case sunday = "sunday"
    case bankHoliday = "bankHoliday"
}

enum PaymentMethod: String, Codable {
    case cash = "cash"
    case contactlessPaymentCard = "contactlessPaymentCard"
    case creditCard = "creditCard"
    case debitCard = "debitCard"
    case directDebit = "directDebit"
    case mobilePhone = "mobilePhone"
}

enum TicketFormat: String, Codable {
    case mobileApp = "mobileApp"
    case paperTicket = "paperTicket"
    case smartCard = "smartCard"
}

enum PurchaseLocation: String, Codable {
    case mobileDevice = "mobileDevice"
    case onBoard = "onBoard"
    case online = "online"
}

struct FullTimeRestriction: Codable {
    let day: TimeRestrictionDay
    let timeBands: [TimeBand]
    
    enum CodingKeys: String, CodingKey {
        case day
        case timeBands
    }
}

// MARK: - TimeRestriction
struct TimeRestriction: Codable {
    let day: String
    let timeBands: [TimeBand]
}

struct TimeBand: Codable {
    let startTime: String
    let endTime: String
}

struct TicketPeriod: Codable {
    let period: TimeBand?
    enum CodingKeys: String, CodingKey {
        case period
    }
}

struct Stop: Codable {
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

// MARK: - PeriodGeoZoneTicket
struct PeriodGeoZoneTicket: Codable {
    let operatorName: String
    let ticket: String
    let products: [Product]
    let zoneName: String
    let stops: [Stop]
    
    enum CodingKeys: String, CodingKey {
        case ticket, zoneName, operatorName
        case products, stops
    }
}

struct BaseTicket: Codable {
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

struct User: Codable{
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
struct Product: Codable {
    let productName, productPrice, productDuration, productValidity: String
    let salesOfferPackages: [SalesOfferPackage]
}

// MARK: - SalesOfferPackage
struct SalesOfferPackage: Codable {
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
