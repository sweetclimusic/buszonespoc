//
//  PocDFTViewModelTests.swift
//  PocDFT
//
//  Created by ashlee.muscroft on 03/09/2021.
//
//

import XCTest
import XMLCoder
@testable import PocDFT

class PocDFTViewModelTests: XCTestCase {
    //explicitly unwrapped here as a XCTFail will be thrown if these do not have a valid object at time of assignment
    var compositeFrameViewModel: CompositeFrameViewModel! = nil

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        runTest("Load operator") { () -> Void in
            var geoZoneTicket: PublicationDelivery! = nil
            guard let xmlData = loadXMLData() else {
                return XCTFail("xml contents could not be loaded")
            }
            let decoder = XMLDecoder()
            decoder.keyDecodingStrategy = .convertFromCapitalized

            do {
                geoZoneTicket = try decoder.decode(PublicationDelivery.self, from: xmlData)
            } catch {
                return XCTFail("Failed to decode XML \(error.localizedDescription)")
            }

            guard let compositeFrames = geoZoneTicket.dataObjects?.compositeFrame
                    else {
                return XCTFail("Unable to access a valid compositeFrame")
            }
            compositeFrameViewModel = CompositeFrameViewModel(compositeFrames: compositeFrames)
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOperatorCanBeFound() throws {
        //using only the model test that you can fetch a operator
        let busOperators = compositeFrameViewModel.fetchOperators()
        _ = busOperators.map {
            XCTAssertEqual($0.busOperator.nocCode,
                    mockOrganization["publicCode"])
        }
    }

    func testOperatorPriceModel() {
        let busOperators = compositeFrameViewModel.fetchOperators()
        var operatorPriceTable: [PriceViewModel]
        runTest("BLAC bus operator has price table") { () -> Void in
            guard let blac = busOperators.first(where: { $0.busOperator.nocCode == "BLAC" })
                    else {
                return XCTFail("Blackpool Transport missing")
            }
            operatorPriceTable = blac.fetchPrices()

            return XCTAssert(!operatorPriceTable.isEmpty)
        }
    }

    func testOperatorProductModel() {
        let blacFares = compositeFrameViewModel.fetchFares(for: "BLAC")
    }

}
