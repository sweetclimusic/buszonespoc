//
//  TransportOperatorViewModel.swift
//  PocDFT
//
//  Created by ashlee.muscroft on 08/09/2021.
//
//

import Combine
import Foundation

class TransportOperatorViewModel: ObservableObject {
    var busOperator: TransportOperator
    var prices: [PriceViewModel] = []
    var products: [ProductViewModel] = []
    var periodFareTable: PeriodFareViewModel? = nil

    init(operator value: TransportOperator) {
        self.busOperator = value
        updateFareTable()
    }

    init(operator: TransportOperator,
         prices: [PriceViewModel],
         products: [ProductViewModel]) {
        self.busOperator = `operator`
        self.prices = prices
        self.products = products
        updateFareTable()
    }

    //TODO build a object that combines prices and products
    func updateFareTable() {
        self.prices = fetchPrices()
        self.products = fetchProducts()
        buildPeriodFareTable()
    }

    func fetchPrices() -> [PriceViewModel] {
        return prices
    }

    func fetchProducts() -> [ProductViewModel] {
        return products
    }

    func buildPeriodFareTable() {
        //periodFareTable = PeriodFareViewModel()
    }

    func fetchPeriodFareTable() -> PeriodFareViewModel? {
        return periodFareTable
    }

    // EXPAND with a fetchLines for bus routes
}

extension TransportOperatorViewModel: Equatable {
    static func ==(lhs: TransportOperatorViewModel, rhs: TransportOperatorViewModel) -> Bool {
        return lhs.busOperator == rhs.busOperator
    }
}