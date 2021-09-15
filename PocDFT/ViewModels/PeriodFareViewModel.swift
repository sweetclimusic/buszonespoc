//
// Created by ashlee.muscroft on 09/09/2021.
//

import Foundation

class PeriodFareViewModel {

    var prices: [PriceViewModel] = []
    var products: Products = Products()
    //one level deeper than fareFrames
    private var fares: FareTables?
    private let nocCode: String
    private let tariff: Tariff?
    private var fareFrames: [FareFrame]? = nil

    init(naptanCode: String, fareTable: FareTables, tariff: Tariff) {
        //extract fares from FareFrame that include Fare_Price KEY
        self.fares = fareTable
        self.tariff = tariff
        self.nocCode = naptanCode
        self.prices = []
        //extract products from resourceFrame
        self.products = extractProducts(from: tariff, with: naptanCode)
    }

    init(naptanCode: String, fareFrames: [FareFrame]? = nil) {
        self.nocCode = naptanCode
        self.fares = nil
        self.tariff = nil
        self.prices = []
        self.products = Products()
        self.fareFrames = fareFrames
        if self.fareFrames != nil {
            // extract tariff, naptanCode and fareTable from fareFrames
        }
    }

    func extractProducts(from operatorTariff: Tariff, with nocCode: String) -> Products {
        let pvm: ProductViewModel = ProductViewModel(naptanCode: nocCode)
        guard let busProducts = pvm.getProductsFromTariffs(from: operatorTariff, for: nocCode)
                else {
            return Products()
        }
        return Products(dictionaryLiteral: (nocCode, busProducts))
    }

}
