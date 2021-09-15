//
// Created by ashlee.muscroft on 02/09/2021.
//

import Combine
import Foundation

/**
    The amount for a ticket is nested in some ugly xml, prices extract the various nested
     objects to be presented in a reasonable order... lift to PriceViewModal instead
 */
class PriceViewModel: ObservableObject {
    @Published var prices: [String] = [String]()
    // Model with listed prices
    private var fareTable: FareTables

    init(fareTable: FareTables) {
        self.fareTable = fareTable
        prices = updatePrices(fareTable: fareTable)
    }

    func updatePrices(fareTable: FareTables? = nil) -> [String] {
        //extractPrices from a FareTable

        return [String]()
    }
}