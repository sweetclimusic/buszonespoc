//
//  PocDFTModelTests.swift
//  PocDFT
//
//  Created by ashlee.muscroft on 09/08/2021.
//

import XCTest
import XMLCoder
@testable import PocDFT

class PocDFTModelTests: XCTestCase {
    //explicitly unwrapped here as a XCTFail will be thrown if these do not have a valid object at time of assignment
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
        } catch {
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

        guard let firstFrame = compositeFrame.first
                else {
            print(sample.debugDescription)
            return XCTFail("Unable to access a valid compositeFrame: \(String(describing: compositeFrame))")
        }

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

        guard let firstFrames = compositeFrame.first else {
            return XCTFail("No frames available")
        }

        //MARK: When I filter for resource frames
        let busOperators = firstFrames.frames?.resourceFrame?.busOperators
        guard let value = busOperators?.first else {
            return XCTFail("Failed to decode busOperator")
        }

        //MARK: Then I can view the organisations details
        XCTAssertEqual(value.nocCode, mockOrganization["publicCode"])
        XCTAssertEqual(value.name, mockOrganization["name"])
        XCTAssertEqual(value.phone, mockOrganization["phone"])
        XCTAssertEqual(value.website, mockOrganization["url"])
        XCTAssertEqual(value.street, mockOrganization["address"])
        XCTAssertEqual(value.email, mockOrganization["email"])
    }

    func testForAListOfStops() throws {
        let mockFareZone = [
            "name": "Test Town Centre",
            "description": "Test Town Centre BLAC_products Zone"
        ]
        //MARK: Given a fareZone in a compositeFrame.FareFrame
        guard let fareFrames = compositeFrame.first?.frames?.fareFrames else {
            return XCTFail("Missing FareFrame from Operator \(String(describing: compositeFrame.first?.name))")
        }
        //MARK: When I extract the members from the first fareZones
        guard let fareZone = fareFrames.first?.fareZones?.fareZone?.first else {
            return XCTFail("Missing fareZones from expected fareFrame")
        }
        XCTAssertNotNil(fareZone)

        //MARK: Then I can view the ScheduleStopPoints
        XCTAssertEqual(mockFareZone["name"], fareZone.name)
        XCTAssertEqual(mockFareZone["description"], fareZone.description)
        guard let stops = fareZone.members?.stops else {
            return XCTFail("Failed to extract any stops")
        }
        XCTAssertEqual(mockStops, stops)
    }

    func testForTariffs() throws {
        //frames.FareFrames.tariffs.Tariff.timeIntervals.TimeInterval.Name
        let frames: [Frames] = compositeFrame.filter {
                    $0.frames != nil
                }
                .compactMap {
                    $0.frames
                }
        let fareFrames: [FareFrame] = frames.filter({
            $0.fareFrames?.filter != nil
        }
        ).flatMap({ $0.fareFrames! })
        let tariffFrames = fareFrames.filter {
                    $0.tariffs != nil
                }
                .compactMap {
                    $0.tariffs
                }
        _ = tariffFrames.map {
            XCTAssertNotNil($0.tariff?.name)
            XCTAssertNotNil($0.tariff?.periods)
            XCTAssertNotNil($0.tariff?.validity)
        }

    }

    func testForProductCosts() throws {
        //FareFrames.fareTables.fareTable.includes.FareTable.includes.FareTable.includes.prices.timeIntervalPrice.Amount
        // Give I have a list of busOperator
        let fareFrames = compositeFrame.first?.frames?.fareFrames?.filter {
            $0.id?.contains("FARE_PRICE") ?? false
        }
        guard let compositeFrameWithPrices = fareFrames else {
            return XCTFail("Could not retrieve a fareFrame with prices")
        }
        guard let fares = compositeFrameWithPrices
                .first?.fareTables?.fares else {
            return XCTFail("Could not retrieve fareTables' fareTable")
        }
        //extract price by filtering product with
        //<@product><@paymentType>@<passenger>@zone@nested@prices

        print(fares)
        var mockFareIndex = 0
        for faretable in fares {
            guard let fare = faretable.extractFare(),
                  let price = fare.price else {
                return XCTFail("Fare at \(mockFareIndex) is null")
            }
            var mockFare = mockFareTables[mockFareIndex]
            var mockPrice = mockFare.price

            XCTAssertEqual(fare.id, mockFare.id)
            XCTAssertEqual(fare.name, mockFare.name)
            XCTAssertEqual(fare.ref, mockFare.ref)
            XCTAssertEqual(price.id, mockPrice.id)
            XCTAssertEqual(price.ref, mockPrice.ref)
            XCTAssertEqual(price.amount, mockPrice.amount)
            mockFareIndex += 1
            //Fare has additional product details, zoneDescription and passengerDescription
            //These are to be string split, and tested
            //that the split parts contain the correct details.
        }


        // Given a Product
        // When I get a tariff by ID
        // Then I am given all prices and the  lenght
        //FareTables
    }

    func testOperatorHasProduct() throws {
        // Give I have a list of busOperator
        guard let serviceOperators = compositeFrame?.first?.frames?.resourceFrame?.busOperators else {
            return XCTFail("Could not retrieve operator")
        }
        // When I select a operator and get products
        guard let opCode = serviceOperators.first?.nocCode else {
            return XCTFail("missing operator code")

        }
        let searchTerm = "\(opCode)_products"
        guard let fareFrame = (compositeFrame.first?.frames?.fareFrames?.filter {
            ($0.tariffs?.tariff?.id?.contains(searchTerm)) ?? false
        }) else {
            return XCTFail("Could not find associated fareFrame for operator")
        }
        let blackPoolTransport = serviceOperators.filter {
            $0.name == "Blackpool Transport"
        }
        if blackPoolTransport.isEmpty {
            XCTFail("Blackpool Transport operator not found")
        }
        guard let operatorTariff = fareFrame.first?.tariffs?.tariff else {
            return XCTFail("Missing operator tariff")
        }
        // Short code of operator
        guard let nocCode = blackPoolTransport.first?.nocCode else {
            return XCTFail("Blackpool Transport has no products")
        }

        let pvm: ProductViewModel = ProductViewModel()
        guard let busProducts = pvm.getProductsFromTariffs(from: operatorTariff, for: nocCode)
                else {
            return XCTFail("Blackpool Transport has no products")
        }
        // Then the operator will have a list of product names
        XCTAssertEqual(busProducts.compactMap {
            $0.productName
        }, mockProductLine.compactMap {
            $0.productName
        })
        // step 2, verify valid tariff dates
        XCTAssertEqual(busProducts.compactMap {
            $0.productValidity
        }, mockProductLine.compactMap {
            $0.productValidity
        })
    }

    //    func testPerformanceExample() throws {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }

}
