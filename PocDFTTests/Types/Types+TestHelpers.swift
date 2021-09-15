//
//  Types+TestHelpers.swift
//  PocDFTTests
//
//  Created by ashlee.muscroft on 12/08/2021.
//

import Foundation
@testable import PocDFT

func loadXMLData(url: String? = "data/periodGeoZone") -> Data? {
    if let fileURL = Bundle.main.url(forResource: url, withExtension: "xml") {
        do {
            let contents = try String(contentsOf: fileURL)
            return contents.data(using: .utf8)
        } catch {
            // contents could not be loaded
            fatalError("xml contents could not be loaded")
        }
    }
    return nil
}

// MARK: - Helper for test testForAListsOfStops
let mockStops: [Stop] = [PocDFT.Stop(name: "The Towers, Park Street, Macclesfield", naptStop: "naptStop:CHEPJWM"), PocDFT.Stop(name: "Dog&Partridge, New Manchester Road, Paddington", naptStop: "naptStop:wrgdpma"), PocDFT.Stop(name: "Manchester Rd, MANCHESTER RD, Hollinwood", naptStop: "naptStop:MANATDWT"), PocDFT.Stop(name: "Bower Fold, Mottram Rd, Bower Fold", naptStop: "naptStop:MANDGADW"), PocDFT.Stop(name: "Oak Road, WARBURTON LANE, Partington", naptStop: "naptStop:MANJTPJW"), PocDFT.Stop(name: "Meadow Close, BOOTH ROAD, Little Lever", naptStop: "naptStop:MANPATDT"), PocDFT.Stop(name: "Church Road, Church Road, Great Plumpton", naptStop: "naptStop:lanatgjp"), PocDFT.Stop(name: "Hare and Hounds, Whalley Road, Clayton-le-Moors", naptStop: "naptStop:lanawtwg"), PocDFT.Stop(name: "Skippool Avenue, Breck Road, Poulton-le-Fylde", naptStop: "naptStop:langjpaw"), PocDFT.Stop(name: "Lytham St Annes HTC, Church Road, Ansdell", naptStop: "naptStop:lanpamtw"), PocDFT.Stop(name: "Torsway Avenue, Newton Drive, Kingscote", naptStop: "naptStop:blpadadw"), PocDFT.Stop(name: "Spencer Court, Talbot Road, Central", naptStop: "naptStop:blpadwgm"), PocDFT.Stop(name: "Mesnes Park, Park Road North, Newton le Willows", naptStop: "naptStop:mergjpjd"), PocDFT.Stop(name: "Grosvenor Road, St Helens Road, Prescot", naptStop: "naptStop:merdwgmt"), PocDFT.Stop(name: "Campbell Avenue, Hamilton Drive, Holgate", naptStop: "naptStop:32900357"), PocDFT.Stop(name: "Bank End Farm, Bank Lane, Howbrook", naptStop: "naptStop:37055608"), PocDFT.Stop(name: "Main Street St Johns Close, Main Street, Aberford", naptStop: "naptStop:45010202"), PocDFT.Stop(name: "Midgley Road Spring Villas, Midgley Road, Mytholmroyd", naptStop: "naptStop:45019529")]
// MARK: - Helper for test testForTariffs
let mockTariffs: [TicketTimePeriod] = [PocDFT.TicketTimePeriod(id: "op:Tariff@Product_1@1-day", name: "1 day", description: "P1D"), PocDFT.TicketTimePeriod(id: "op:Tariff@Product_2@2-weeks", name: "2 weeks", description: "P14D"), PocDFT.TicketTimePeriod(id: "op:Tariff@Product_3@5-years", name: "5 years", description: "P5Y"), PocDFT.TicketTimePeriod(id: "op:Tariff@Product_4@7-years", name: "7 years", description: "P7Y"), PocDFT.TicketTimePeriod(id: "op:Tariff@Product_5@28-weeks", name: "28 weeks", description: "P196D")]

// Helper for next Mock
fileprivate let mockValidProduct: Valid = Valid(fromDate: "2010-12-17T09:30:46.0Z", toDate: "2028-12-17T09:30:46.0Z")

// MARK: - Mock data for testOperatorHasProduct test
let mockProductLine: [Product] = [
    PocDFT.Product(
            id: "op:Tariff@Product_1@1-day",
            productName: "1 day",
            productPrice: "",
            productDuration: "",
            productValidity: mockValidProduct),
    PocDFT.Product(
            id: "op:Tariff@Product_2@2-weeks",
            productName: "2 weeks",
            productPrice: "",
            productDuration: "",
            productValidity: mockValidProduct),
    PocDFT.Product(
            id: "op:Tariff@Product_3@5-years",
            productName: "5 years",
            productPrice: "",
            productDuration: "",
            productValidity: mockValidProduct),
    PocDFT.Product(
            id: "op:Tariff@Product_4@7-years",
            productName: "7 years",
            productPrice: "",
            productDuration: "",
            productValidity: mockValidProduct),
    PocDFT.Product(
            id: "op:Tariff@Product_5@28-weeks",
            productName: "28 weeks",
            productPrice: "",
            productDuration: "",
            productValidity: mockValidProduct)
]
// MARK: - Mock data for testForProductCosts test
let mockFareTables: [MockFare] = [
    MockFare(
            id: "op:fareTable@Product_1@Onboard_(cash)@zone",
            name: "Product 1 - Onboard (cash) - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_1@Onboard_(cash)@zone",
                    ref: "op:Tariff@Product_1@1-day",
                    amount: "3")),
    MockFare(
            id: "op:fareTable@Product_1@Onboard_(contactless)@zone",
            name: "Product 1 - Onboard (contactless) - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_1@Onboard_(contactless)@zone",
                    ref: "op:Tariff@Product_1@1-day",
                    amount: "3")),
    MockFare(
            id: "op:fareTable@Product_1@Online_(smart_card)@zone",
            name: "Product 1 - Online (smart card) - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_1@Online_(smart_card)@zone",
                    ref: "op:Tariff@Product_1@1-day",
                    amount: "3")),
    MockFare(
            id: "op:fareTable@Product_1@Mobile_App@zone",
            name: "Product 1 - Mobile App - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_1@Mobile_App@zone",
                    ref: "op:Tariff@Product_1@1-day",
                    amount: "3")),
    MockFare(
            id: "op:fareTable@Product_2@Onboard_(cash)@zone",
            name: "Product 2 - Onboard (cash) - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_2@Onboard_(cash)@zone",
                    ref: "op:Tariff@Product_2@2-weeks",
                    amount: "5")),
    MockFare(
            id: "op:fareTable@Product_2@Onboard_(contactless)@zone",
            name: "Product 2 - Onboard (contactless) - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_2@Onboard_(contactless)@zone",
                    ref: "op:Tariff@Product_2@2-weeks",
                    amount: "5")),
    MockFare(
            id: "op:fareTable@Product_2@Online_(smart_card)@zone",
            name: "Product 2 - Online (smart card) - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_2@Online_(smart_card)@zone",
                    ref: "op:Tariff@Product_2@2-weeks",
                    amount: "5")),
    MockFare(
            id: "op:fareTable@Product_2@Mobile_App@zone",
            name: "Product 2 - Mobile App - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_2@Mobile_App@zone",
                    ref: "op:Tariff@Product_2@2-weeks",
                    amount: "5")),
    MockFare(
            id: "op:fareTable@Product_3@Onboard_(contactless)@zone",
            name: "Product 3 - Onboard (contactless) - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_3@Onboard_(contactless)@zone",
                    ref: "op:Tariff@Product_3@5-years", amount: "10")),
    MockFare(
            id: "op:fareTable@Product_3@Online_(smart_card)@zone",
            name: "Product 3 - Online (smart card) - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_3@Online_(smart_card)@zone",
                    ref: "op:Tariff@Product_3@5-years",
                    amount: "10")),
    MockFare(
            id: "op:fareTable@Product_3@Mobile_App@zone",
            name: "Product 3 - Mobile App - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_3@Mobile_App@zone",
                    ref: "op:Tariff@Product_3@5-years",
                    amount: "10")),
    MockFare(
            id: "op:fareTable@Product_3@All_Encompassing@zone",
            name: "Product 3 - All Encompassing - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_3@All_Encompassing@zone",
                    ref: "op:Tariff@Product_3@5-years",
                    amount: "10")),
    MockFare(
            id: "op:fareTable@Product_4@Onboard_(cash)@zone",
            name: "Product 4 - Onboard (cash) - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_4@Onboard_(cash)@zone",
                    ref: "op:Tariff@Product_4@7-years",
                    amount: "15")),
    MockFare(
            id: "op:fareTable@Product_4@Onboard_(contactless)@zone",
            name: "Product 4 - Onboard (contactless) - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_4@Onboard_(contactless)@zone",
                    ref: "op:Tariff@Product_4@7-years",
                    amount: "15")),
    MockFare(
            id: "op:fareTable@Product_5@onboard_sales_offer_package@zone",
            name: "Product 5 - onboard sales offer package - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_5@onboard_sales_offer_package@zone",
                    ref: "op:Tariff@Product_5@28-weeks",
                    amount: "30")),
    MockFare(
            id: "op:fareTable@Product_5@mobile_app_offer_package@zone",
            name: "Product 5 - mobile app offer package - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_5@mobile_app_offer_package@zone",
                    ref: "op:Tariff@Product_5@28-weeks",
                    amount: "30")),
    MockFare(
            id: "op:fareTable@Product_5@online_offer_package@zone",
            name: "Product 5 - online offer package - Test Town Centre",
            ref: "op:BLAC_products@Test_Town_Centre",
            price: MockPrices(
                    id: "op:Product_5@online_offer_package@zone",
                    ref: "op:Tariff@Product_5@28-weeks",
                    amount: "30"))]

struct MockFare {
    var id: String = ""
    var name: String = ""
    var ref: String = ""
    var price: MockPrices = MockPrices()
}

struct MockPrices {
    var id: String = ""
    var ref: String = ""
    var amount: String = ""

    init(id newIdValue: String = "",
         ref newRefValue: String = "",
         amount newAmountValue: String = "") {
        id = newIdValue
        amount = newAmountValue
        ref = newRefValue
    }
}

// MARK: Given a mockOrganization and I have extract the compositeFrames
let mockOrganization: [String: String] =
        [
            "publicCode": "BLAC",
            "name": "Blackpool Transport",
            "shortName": "Blackpool Transport",
            "tradingName": "Blackpool Transport Services Ltd",
            "phone": "01253 473001",
            "url": "http://www.blackpooltransport.com",
            "address": "Rigby Road, Blackpool FY1 5DD",
            "email": "enquiries@blackpooltransport.com"
        ]

import XCTest

extension PocDFTViewModelTests {
    /**Helper function to XCTActivity within the PocDFTViewModelTests
    runTest will be embedded into a standard XCTest function so it is required to rethrow
    for the parent function to capture any nested fatales */
    func runTest<T>(_ description: String, subBlock: () throws -> T) rethrows -> T {
        // Use try as a normal runActivity throws
        // and use try in the closure as the subBlock could throw
        try XCTContext.runActivity(named: description, block: { _ in try subBlock() })
    }
}