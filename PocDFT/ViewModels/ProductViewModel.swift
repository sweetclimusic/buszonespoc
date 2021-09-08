//
//  ProductViewModel.swift
//  PocDFT
//
//  Created by ashlee.muscroft on 01/09/2021.
//

import Combine
import Foundation

// MARK: - Product
typealias Products = [String: [Product]]

class ProductViewModel: ObservableObject {
    @Published var operatorProducts = Products()
//    ///Products
//    var productName,
//        productPrice,
//        productDuration: String
//    var productValidity: Valid
    init() {
        updateProducts()
    }

    private func fetchPrice() {

    }

    private func fetchProductDetails() {

    }

    private func fetchValidity() {

    }

    func updateProducts() {
        fetchValidity()
        fetchPrice()
        fetchProductDetails()
    }

    func fetchProducts(whereProductName filter: String? = nil) -> Products {
        if filter != nil, let filter = filter {
            return operatorProducts.filter { key, value in
                // value and array of products for the operator
                let filteredValues = value.filter {
                    guard let productName = $0.productName else {
                        return false
                    }
                    return productName.contains(filter)
                }
                return filteredValues.count > 0
            }
        }
        return operatorProducts
    }

    // fetchProducts for a operator based on the naptanCode
    func fetchProducts(for naptanCode: String) -> [Product]? {
        let allProducts = self.fetchProducts()
        return allProducts.keys.contains(naptanCode) ?
                allProducts[naptanCode] : nil
    }
}

// Helpers are used to extract tariffs, products and tickets for a given operator.
extension ProductViewModel {
    /// Get Products for the given tariff object
    /// - Parameter:
    ///     - tariff:  Tariff object with nested products
    ///     - nocCode: ensure objects has been processed correctly from xml when present
    func getProductsFromTariffs(from tariff: Tariff, for nocCode: String) -> [Product]? {
        var products = [Product]()

        if tariff.id?.contains(nocCode) != nil,
           let periods = tariff.periods {
            for element in periods {
                let product = Product(
                        id: element.id,
                        productName: element.name ?? "",
                        productPrice: nil,
                        productDuration: nil,
                        productValidity: tariff.validity
                )
                products.append(product)
            }

            return products
        }
        return nil
    }

    func getProductPricesFromFareTable(byId id: String, tariff: Tariff) -> [Product]? {
        /**
        //given a FareFrames.fareTables, for each faretable look at the fare *Name*
        //
        //using existing Product Array, look at the id for each product,
        //cross compare your product ID to that in the farestable for a match?
        //FareFrames.fareTables.fareTable.includes.FareTable.includes.FareTable...

         */
        return nil
    }
}