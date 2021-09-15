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
    var products: Products = Products()
    //one level deeper than fareFrames
    private var fareTables: FareTables?
    private let nocCode: String
    private let tariff: Tariff?
    private var fareFrames: [FareFrame]? = nil

    init(naptanCode: String, fareTables: FareTables, tariff: Tariff) {
        //extract fares from FareFrame that include Fare_Price KEY
        self.fareTables = fareTables
        self.tariff = tariff
        self.nocCode = naptanCode
        //extract products from resourceFrame
        if let operatorProducts = getProductsFromTariffs(from: tariff, for: naptanCode) {
            self.products = Products(dictionaryLiteral: (naptanCode, operatorProducts))
        }
    }

    init(naptanCode: String, fareFrames: [FareFrame]? = nil) {
        self.nocCode = naptanCode
        self.fareTables = nil
        self.tariff = nil
        self.products = Products()
        self.fareFrames = fareFrames
        if self.fareFrames != nil {
            // extract tariff, naptanCode and fareTable from fareFrames
        }
    }

//    ///Products
//    var productName,
//        productPrice,
//        productDuration: String
//    var productValidity: Valid

    private func fetchProductDetails() {

    }

    private func fetchValidity(byId id: String) -> Valid? {
        let filteredValue = products.compactMapValues { value in
            value.filter {
                $0.productName == id
            }
        }
        return filteredValue.first?.value.first?.productValidity
    }

    func updateProducts(naptanCode: String, tariff: Tariff) {
        if let operatorProducts = getProductsFromTariffs(from: tariff, for: nocCode) {
            var updatedProducts = Products(dictionaryLiteral: (naptanCode, operatorProducts))
            guard let updatedValues = getProductPricesFromFareTable(byId: "", tariff: tariff) else {
                return
            }
            updatedProducts.updateValue(updatedValues, forKey: naptanCode)
            // MARK: - preform merger of above operations
            // This closure will take the new value for uniqueKey:
            // ref: https://developer.apple.com/documentation/swift/dictionary/3127171-merge
            self.products.merge(updatedProducts) { (_, new) in
                new
            }
        }
    }

    func fetchProducts(whereProductName filter: String? = nil) -> Products {
        if filter != nil, let filter = filter {
            return operatorProducts.mapValues { value in
                value.filter {
                    $0.productName == filter
                }
            }
//            return operatorProducts.filter { key, value in
//                // value and array of products for the operator
//                let filteredValues = value.filter {
//                    guard let productName = $0.productName else {
//                        return false
//                    }
//                    return productName.contains(filter)
//                }
//                return filteredValues.count > 0
//            }
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
         // id like op:Tariff@Product_1@1-day
         // name like 1 day
        */
        //using existing Product Array, look at the id for each product,
        //cross compare your product ID to that in the farestable for a match?
        //FareFrames.fareTables.fareTable.includes.FareTable.includes.FareTable...

        // TODO needs lots of tests
        var products: [Product]? = nil
        if let tariffId = tariff.id, tariffId.contains(nocCode) {
            var products = operatorProducts[nocCode]!
            //extract common product name from tariff, when id like "op:Tariff@Product_1@1-day" extract "Product_1:
            if let productTags = tariff.getProductTags(),
               // all products in the tariff have been converted to tags
               productTags.count == tariff.periods?.count {
                //each productTag should have a tag like "Product 1"
                for tag in productTags {
                    let productFare = self.fareTables?.fares?.filter {
                        $0.id?.contains(tag) ?? false
                    }.first?.extractFare()
                    //update fare pricing on product
                    _ = products.enumerated().map { index, value in
                        if let valueId = value.id, // check
                           valueId.contains(id) {
                            // then update the productPrice from fares
                            products[index].productPrice = productFare?.price?.amount
                        }
                    }
                }
            }
        }
        return products
    }
}