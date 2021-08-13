//
//  Types+TestHelpers.swift
//  PocDFTTests
//
//  Created by ashlee.muscroft on 12/08/2021.
//

import Foundation

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
