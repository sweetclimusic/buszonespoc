//
// Created by ashlee.muscroft on 08/09/2021.
//

import Foundation
import XMLCoder

// A compositeFrameViewModel contains the flat structure and helper methods from
// the xmlTypes
class CompositeFrameViewModel {
    // BusOperator encompasses xml transcoded type TransportOperator and helpers
    // fetchOperator, fetchFares, fetchProducts
    private var compositeFrames: [CompositeFrame]
    private var operators: [TransportOperatorViewModel] = Array()
    private var operatorBusFares: Products = Products()

    init(compositeFrames: [CompositeFrame]) {
        self.compositeFrames = compositeFrames
        operators = extractTransportOperators()
        operatorBusFares = updateOperatorFares()
    }


    private func extractTransportOperators() -> [TransportOperatorViewModel] {
        var data = [TransportOperatorViewModel]()
        let transportOperators = compositeFrames.compactMap(\.frames?.resourceFrame?.busOperators)
        _ = transportOperators.compactMap {
            guard let value = $0.first else {
                return
            }
            let viewModel = TransportOperatorViewModel(operator: value)
            data.append(viewModel)
        }
        return data
    }

    func fetchOperators() -> [TransportOperatorViewModel] {
        operators
    }

    /// updateOperatorFares
    /// Build a unique key dictionary of all operators by naptanCode with periodfareTable as the values
    /// - Returns: [naptancode: String, fares: PeriodFareTable]
    func updateOperatorFares() -> Products {
        // group the operators for filtering fares
        let grouping = Dictionary(
                grouping: operators,
                by: \TransportOperatorViewModel.busOperator.shortName)
        let fares = grouping.mapValues { value in
            value.compactMap(\.periodFareTable)
        }
        guard let naptanCodes = Array(grouping.keys) as? [String] else {
            return [:]
        }
        guard let fareTables = Array(fares.values) as? [Product] else {
            return Dictionary(uniqueKeysWithValues: zip(naptanCodes, []))
        }
        return Dictionary(uniqueKeysWithValues: zip(naptanCodes, fareTables))
    }

    func fetchFares(for nocCode: String) -> Products {
        if operatorBusFares.keys.contains(nocCode) {
            return operatorBusFares
        }
        return Products(dictionaryLiteral: (naptanCode: nocCode, []))
    }
}