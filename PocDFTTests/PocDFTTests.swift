//
//  PocDFTTests.swift
//  PocDFTTests
//
//  Created by ashlee.muscroft on 09/08/2021.
//

import XCTest
import XMLCoder
@testable import PocDFT

class PocDFTTests: XCTestCase {

    var geoZoneTicket: PublicationDelivery! = nil
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        guard let xmlData = loadXMLData() else {
            return XCTFail("xml contents could not be loaded")
        }
        let decoder = XMLDecoder()
        decoder.keyDecodingStrategy = .convertFromCapitalized
        let decoded = try decoder.decode([String: [String: String]].self, from: xmlData)
        geoZoneTicket = try? decoder.decode(PublicationDelivery.self, from: xmlData)
        print(decoded)
        print(geoZoneTicket!)
        XCTAssertNotNil(geoZoneTicket)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodeASampleXML() throws {
        // This is the first test, can we read XML to swift types
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //XCTAssertNotNil(geoZoneTicket.operatorName)
        //XCTAssertNotNil(geoZoneTicket.zoneName)
//        XCTAssertNotNil(geoZoneTicket.products)
//        XCTAssertNotNil(geoZoneTicket.fareZones)
    }
    
    func testOperatorName() throws {
        //XCTAssertEqual(geoZoneTicket.operatorName, "Fares for Blackpool Transport")
        print(geoZoneTicket.debugDescription)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
