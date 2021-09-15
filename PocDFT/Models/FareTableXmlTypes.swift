//
// Created by ashlee.muscroft on 03/09/2021.
//

import Foundation
import XMLCoder

//MARK: Prices
struct FareTables: Decodable {
    let fares: [FareTable]?

    private enum CodingKeys: String, CodingKey {
        case fares = "fareTable"
    }
}

// MARK: FareTables containing name and references to Products
struct FareTable: Decodable, DynamicNodeDecoding {
    let id: String? // id like  "op:fareTable@Product_1@Onboard_(contactless)@zone"
    let name: String? // name like "Product 1 - Onboard (contactless) - Test Town Centre"
    //let priceRef: String? //pricesFor/PreassignedFareProductRef.ref
    private let includes: Includes?

    static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        .elementOrAttribute
    }
}

// MARK: - FirstLevel Includes
fileprivate struct Includes: Decodable {
    let fareTable: NestedFareTable?
}

// MARk: - Second Level FareTable
fileprivate struct NestedFareTable: Decodable {
    let name: String?
    let specifics: Specifics?
    private let nestedIncludes: NestedIncludes?
    var fareResults: Prices? {
        guard let finalFareTable = nestedIncludes?
                .nextNestedFareTable?
                .finalIncludes?
                .finalFareTable,
              let price = finalFareTable.price
                else {
            return nil
        }
        return price
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case specifics
        case nestedIncludes = "includes"
    }

    struct Specifics: Decodable {
        private let tariffZoneRef: TariffZoneRef?
        var ref: String? {
            tariffZoneRef?.ref
        }

        private struct TariffZoneRef: Decodable, DynamicNodeDecoding {
            let ref: String?

            private enum CodingKeys: String, CodingKey {
                case ref
            }

            static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
                .attribute
            }
        }
    }
}

// MARK: - nestedIncludes
//contain another FareTable -> includes -> FareTable
//we need to be in the finalFareTable to extract Prices
fileprivate struct NestedIncludes: Decodable {
    let nextNestedFareTable: NextNestedFareTable?

    private enum CodingKeys: String, CodingKey {
        case nextNestedFareTable = "fareTable"
    }

    fileprivate struct NextNestedFareTable: Decodable {
        let finalIncludes: FinalIncludes?

        private enum CodingKeys: String, CodingKey {
            case finalIncludes = "includes"
        }
    }
}

fileprivate struct FinalIncludes: Decodable {
    let finalFareTable: FinalFareTable?

    // MARK: Final level of the FareTable with the desired object
    fileprivate struct FinalFareTable: Decodable, DynamicNodeDecoding {
        let id: String?
        let price: Prices?

        private enum CodingKeys: String, CodingKey {
            case id
            case price = "prices"
        }

        // required define to extract the attribute id from FareTable element
        static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
            .elementOrAttribute
        }
    }

    private enum CodingKeys: String, CodingKey {
        case finalFareTable = "fareTable"
    }
}

// MARK: - Prices
struct Prices: Decodable {
    private let timeIntervalPrice: TimeIntervalPrice?

    var amount: String? {
        get {
            timeIntervalPrice?.amount
        }
    }

    var id: String? {
        get {
            timeIntervalPrice?.id
        }
    }

    var ref: String? {
        get {
            timeIntervalPrice?.ref
        }
    }

    private enum CodingKeys: String, CodingKey {
        case timeIntervalPrice
    }

    private struct TimeIntervalPrice: Decodable, DynamicNodeDecoding {
        let id: String?
        private let timeIntervalRef: TimeIntervalRef?
        var ref: String? {
            get {
                timeIntervalRef?.ref
            }
        }
        let amount: String?

        private enum CodingKeys: String, CodingKey {
            case id, amount
            case timeIntervalRef
        }

        static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
            switch key {
            case CodingKeys.id:
                return .attribute
            default:
                return .element
            }
        }

        private struct TimeIntervalRef: Decodable, DynamicNodeDecoding {
            let ref: String?

            static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
                .attribute
            }
        }
    }
}

extension FareTable {
    enum FareTableDataKeys: Int {
        case Product = 0
        case PaymentMethod = 1
        case PassengerOrZone = 2
    }

    func extractFare(splitDescriptionWith character: String? = " - ") -> Fare? {
        var newFare = Fare()
        guard let id = self.id,
              let name = self.name,
              let ref = includes?.fareTable?.specifics?.ref,
              let farePrice = includes?.fareTable?.fareResults else {
            return nil
        }
        // id like: op:fareTable@Product_1@Onboard_(cash)@zone
        newFare.id = id
        // name like: Product 1 - Onboard (cash) - Test Town Centre
        newFare.name = name

        if let separator = character {
            let zoneStrings = name.components(separatedBy: separator)
            newFare.zoneDescription = extractFareData(from: zoneStrings, for: .PassengerOrZone)
            // name like: Product 1 - Onboard (cash)  - adult
            if let iftName = includes?.fareTable?.name {
                let passenger = iftName.components(separatedBy: separator)
                newFare.passengerDescription = extractFareData(from: passenger, for: .PassengerOrZone)
            }
        }
        /** Unused but captured from XML
        // id like: op:Product_1@Onboard_(cash)@adult@product-0@SOP-0@zone
        let fTIncludesFTId = includes?.fareTable?.id
        */

        // specifics ref like: op:BLAC_products@Test_Town_Centre
        newFare.ref = ref
        // results as FarePrice
        //id like: op:Product_1@Onboard_(cash)@adult@zone@nested@prices
        //Price.id like: op:Product_1@Onboard_(cash)@zone
        //Price.amount like: 3
        //Price.id like: op:Tariff@Product_1@1-day
        newFare.price = farePrice
        return newFare
    }

    ///"product", "Payment type" , "Zone"/"Passenger"
    private func extractFareData(from data: [String], for key: FareTableDataKeys = .PassengerOrZone) -> String {
        if key.rawValue < data.count {
            return data[key.rawValue]
        }
        return ""
    }
}