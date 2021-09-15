//
//  XmlTypes.swift
//  PocDFT
//
//  Created by ashlee.muscroft on 17/08/2021.
//

import Foundation
import XMLCoder

// MARK: - PeriodGeoZoneTicket
struct PeriodGeoZoneTicket: Decodable {
    let publicationDelivery: PublicationDelivery

    enum CodingKeys: String, CodingKey {
        case publicationDelivery = "publicationDelivery"
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
    var fareFrames: [FareFrame]?

    enum CodingKeys: String, CodingKey {
        case resourceFrame = "resourceFrame"
        case fareFrames = "fareFrame"
    }
}

// MARK: - Valid
struct Valid: Decodable, Equatable {
    private let from, to: String?

    init(fromDate from: String, toDate to: String) {
        self.from = from
        self.to = to
    }

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
    // MARK: readOnly computed properties
    var phone: String {
        get {
            self.contactDetails?.first?.phone ?? ""
        }
    }

    var website: String {
        get {
            self.contactDetails?.first?.url ?? ""
        }
    }

    var street: String {
        get {
            self.address?.first?.street ?? ""
        }
    }

    var email: String {
        get {
            self.customerServiceDetails?.first?.email ?? ""
        }
    }

    private enum CodingKeys: String, CodingKey {
        case nocCode = "publicCode"
        case name, shortName, tradingName
        //Union
        case contactDetails, address
        case customerServiceDetails = "customerServiceContactDetails"
    }
}

// MARK: FareFrame
struct FareFrame: Decodable, DynamicNodeDecoding {
    static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        .elementOrAttribute
    }

    var id: String?
    var fareZones: FareZones?
    var fareTables: FareTables?

    struct FareZones: Decodable {
        let fareZone: [FareZone]?
    }

    var tariffs: Tariffs?

    //frames.FareFrames.tariffs.Tariff.timeIntervals.TimeInterval.Name
    struct Tariffs: Decodable {
        let tariff: Tariff?

        private enum CodingKeys: String, CodingKey {
            case tariff = "tariff"
        }
    }
}

struct FareZone: Decodable {
    let name: String?
    let description: String?
    let members: Members?

    struct Members: Decodable {
        let stops: [Stop]?

        private enum CodingKeys: String, CodingKey {
            case stops = "scheduledStopPointRef"
        }
    }

    private enum CodingKeys: String, CodingKey {
        case name, description
        case members
    }
}

struct Stop: Decodable, DynamicNodeDecoding {
    let name: String?
    let naptStop: String?

    private enum CodingKeys: String, CodingKey {
        case name = ""
        case naptStop = "ref"
    }

    static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
        case CodingKeys.naptStop:
            return .attribute
        default:
            return .element
        }
    }
}

struct Tariff: Decodable, DynamicNodeDecoding {
    let id: String?
    let name: String?
    //Helper variables for nested decoding
    private let validityConditions: Validity?
    private let timeIntervals: TimeIntervals?

    private enum CodingKeys: String, CodingKey {
        case name
        case timeIntervals
        case id
        case validityConditions
    }

    func getProductTags() -> [String]? {
        guard let periods: [TicketTimePeriod] = self.timeIntervals?.ticketTimePeriod else {
            return nil
        }
        return periods.map(\.id)
                .map { str -> [String] in
                    guard let str = str else {
                        return []
                    }
                    var tags = str.split(separator: "@", maxSplits: 2)
                    if tags.count > 1 {
                        tags.removeFirst()
                    }
                    return tags.map {
                        $0.replacingOccurrences(of: "_", with: " ")
                    }
                }
                .flatMap {
                    $0
                }
    }

    // Helper structs to extract nested objects
    private struct TimeIntervals: Decodable {
        let ticketTimePeriod: [TicketTimePeriod]?

        private enum CodingKeys: String, CodingKey {
            case ticketTimePeriod = "timeInterval"
        }
    }

    private struct Validity: Decodable {
        let validBetween: Valid?

        private enum CodingKeys: String, CodingKey {
            case validBetween
        }
    }

    var periods: [TicketTimePeriod]? {
        get {
            timeIntervals?.ticketTimePeriod
        }
    }
    var validity: Valid? {
        get {
            validityConditions?.validBetween
        }
    }

    static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
        case CodingKeys.id:
            return .attribute
        default:
            return .element
        }
    }
}

struct TicketTimePeriod: Decodable, Equatable {
    let id: String?
    let name: String?
    let description: String?

    private enum CodingKeys: String, CodingKey {
        case id, name, description
    }
}

//MARK: - NotImplemented, one day a DB or API that has lat long to map to stops naptanCodes
struct StopData {
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

// MARK: - Extensions
extension Stop: Equatable {
    static func ==(lhs: Stop, rhs: Stop) -> Bool {
        // if any are optional exit out
        guard let rname = rhs.name,
              let lname = lhs.name,
              let rnapt = rhs.naptStop,
              let lnapt = lhs.naptStop else {
            return false
        }
        return rname == lname && lnapt == rnapt
    }
}

extension TicketTimePeriod: DynamicNodeDecoding {
    static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
        case CodingKeys.id:
            return .attribute
        default:
            return .element
        }
    }
}

extension TransportOperator: Equatable {
    public static func ==(lhs: TransportOperator, rhs: TransportOperator) -> Bool {
        let coreEquatable =
                lhs.nocCode == rhs.nocCode &&
                        lhs.name == rhs.name &&
                        lhs.street == rhs.street &&
                        lhs.phone == rhs.phone &&
                        lhs.website == rhs.website &&
                        lhs.email == rhs.email
        //optional naming details for operator exist
        if let lShort = lhs.shortName,
           let rShort = rhs.shortName,
           let lTrading = lhs.tradingName,
           let rTrading = rhs.tradingName {
            return
                    rTrading == lTrading
                            && rShort == lShort
                            && coreEquatable
        }
        return coreEquatable
    }
}
