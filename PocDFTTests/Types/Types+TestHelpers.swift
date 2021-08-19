//
//  Types+TestHelpers.swift
//  PocDFTTests
//
//  Created by ashlee.muscroft on 12/08/2021.
//

import Foundation
@testable import PocDFT
func loadXMLData() -> Data? {
    if let fileURL = Bundle.main.url(forResource: "data/periodGeoZone", withExtension: "xml") {
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

let mockStops: [Stop] = [PocDFT.Stop(name: "The Towers, Park Street, Macclesfield", naptStop: "naptStop:CHEPJWM"), PocDFT.Stop(name: "Dog&Partridge, New Manchester Road, Paddington", naptStop: "naptStop:wrgdpma"), PocDFT.Stop(name: "Manchester Rd, MANCHESTER RD, Hollinwood", naptStop: "naptStop:MANATDWT"), PocDFT.Stop(name: "Bower Fold, Mottram Rd, Bower Fold", naptStop: "naptStop:MANDGADW"), PocDFT.Stop(name: "Oak Road, WARBURTON LANE, Partington", naptStop: "naptStop:MANJTPJW"), PocDFT.Stop(name: "Meadow Close, BOOTH ROAD, Little Lever", naptStop: "naptStop:MANPATDT"), PocDFT.Stop(name: "Church Road, Church Road, Great Plumpton", naptStop: "naptStop:lanatgjp"), PocDFT.Stop(name: "Hare and Hounds, Whalley Road, Clayton-le-Moors", naptStop: "naptStop:lanawtwg"), PocDFT.Stop(name: "Skippool Avenue, Breck Road, Poulton-le-Fylde", naptStop: "naptStop:langjpaw"), PocDFT.Stop(name: "Lytham St Annes HTC, Church Road, Ansdell", naptStop: "naptStop:lanpamtw"), PocDFT.Stop(name: "Torsway Avenue, Newton Drive, Kingscote", naptStop: "naptStop:blpadadw"), PocDFT.Stop(name: "Spencer Court, Talbot Road, Central", naptStop: "naptStop:blpadwgm"), PocDFT.Stop(name: "Mesnes Park, Park Road North, Newton le Willows", naptStop: "naptStop:mergjpjd"), PocDFT.Stop(name: "Grosvenor Road, St Helens Road, Prescot", naptStop: "naptStop:merdwgmt"), PocDFT.Stop(name: "Campbell Avenue, Hamilton Drive, Holgate", naptStop: "naptStop:32900357"), PocDFT.Stop(name: "Bank End Farm, Bank Lane, Howbrook", naptStop: "naptStop:37055608"), PocDFT.Stop(name: "Main Street St Johns Close, Main Street, Aberford", naptStop: "naptStop:45010202"), PocDFT.Stop(name: "Midgley Road Spring Villas, Midgley Road, Mytholmroyd", naptStop: "naptStop:45019529")]
// MARK: - Helper for test testForTariffs
let mockTariffs: [TicketTimePeriod] = [PocDFT.TicketTimePeriod(id: "op:Tariff@Product_1@1-day", name: "1 day", description: "P1D"), PocDFT.TicketTimePeriod(id: "op:Tariff@Product_2@2-weeks", name: "2 weeks", description: "P14D"), PocDFT.TicketTimePeriod(id: "op:Tariff@Product_3@5-years", name: "5 years", description: "P5Y"), PocDFT.TicketTimePeriod(id: "op:Tariff@Product_4@7-years", name: "7 years", description: "P7Y"), PocDFT.TicketTimePeriod(id: "op:Tariff@Product_5@28-weeks", name: "28 weeks", description: "P196D")]
