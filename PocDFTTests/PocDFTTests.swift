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
    //explicitedly unwrapped here as a XCTFail will be thrown if these do not have a valid object at time of assignment
    var geoZoneTicket: PublicationDelivery! = nil
    var compositeFrame: [CompositeFrame]! = nil
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        guard let xmlData = loadXMLData() else {
            return XCTFail("xml contents could not be loaded")
        }
        let decoder = XMLDecoder()
        decoder.keyDecodingStrategy = .convertFromCapitalized
        do {
            geoZoneTicket = try decoder.decode(PublicationDelivery.self, from: xmlData)
        }
        catch {
            XCTFail("Failed to decode XML \(error.localizedDescription)")
        }
        
        XCTAssertNotNil(geoZoneTicket)

        guard let compositeFrame = geoZoneTicket.dataObjects?.compositeFrame
        else {
            return XCTFail("Unable to access a valid compositeFrame")
        }
        self.compositeFrame = compositeFrame
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodeASampleXML() throws {
        // This is the first test, can we read XML to swift types
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let sample = geoZoneTicket.dataObjects
        print(sample.debugDescription)
        guard let firstFrame = compositeFrame.first
        else {
            return XCTFail("Unable to access a valid compositeFrame: \(String(describing: compositeFrame))")
        }
        print(firstFrame.self)
        XCTAssertNotNil(firstFrame.name)
        XCTAssertNotNil(firstFrame.description)
        XCTAssertNotNil(firstFrame.frames)
        guard let secondFrameValidBetween = compositeFrame[1].validBetween else {
            return XCTFail("Failed to access second compositeFrame: \(String(describing: compositeFrame))")
        }
        XCTAssertNotNil(secondFrameValidBetween.fromDate)
        XCTAssertNotNil(secondFrameValidBetween.toDate)
    }
    
    func testFirstOperator() throws {
        //MARK: Given
        guard let firstFrame = compositeFrame.first else {
            return XCTFail("Unable to access a valid compositeFrame")
        }
        
        //MARK: When
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let expectedFromDate = dateFormatter.date(from: "2019-05-01T00:00:00")
        let expectedToDate = dateFormatter.date(from: "2022-12-31T12:00:00")
        guard let secondFrameValidBetween = compositeFrame[1].validBetween else {
            return XCTFail("Failed to access second compositeFrame: \(String(describing: compositeFrame))")
        }
        XCTAssertNotNil(secondFrameValidBetween.fromDate)
        XCTAssertNotNil(secondFrameValidBetween.toDate)
        //MARK: Then
        XCTAssertEqual(firstFrame.name, "Fares for Blackpool Transport")
        XCTAssertEqual(firstFrame.description, "Period ticket for Blackpool Transport")
        XCTAssertEqual(secondFrameValidBetween.fromDate, expectedFromDate)
        XCTAssertEqual(secondFrameValidBetween.toDate, expectedToDate)
    }

    func testResourceFrame() throws {
        // MARK: Given a mockOrganization and I have extract the compositeFrames
        let mockOrganization: [String:String] =
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
        
        guard let firstFrames = compositeFrame.first else {
            return XCTFail("No frames available")
        }
        
        //MARK: When I filter for resource frames
        let busOperators = firstFrames.frames?.resourceFrame?.busOperators
        guard let value = busOperators?.first else {
            return XCTFail("Failed to decode busOperator")
        }

        //MARK: Then I can view the organisations details
        XCTAssertEqual(value.nocCode , mockOrganization["publicCode"] )
        XCTAssertEqual(value.name,mockOrganization["name"] )
        XCTAssertEqual(value.phone(), mockOrganization["phone"])
        XCTAssertEqual(value.website(), mockOrganization["url"])
        XCTAssertEqual(value.street(), mockOrganization["address"])
        XCTAssertEqual(value.email(), mockOrganization["email"])
    }
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
