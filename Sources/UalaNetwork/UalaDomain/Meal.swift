//
//  File.swift
//  
//
//  Created by Miguel Angel Olmedo Perez on 02/03/21.
//

import Foundation

public struct Meal: Codable {
    public let idMeal, strMeal: String
    let strDrinkAlternate: JSONNull?
    public let strCategory, strArea, strInstructions: String
    let strMealThumb: String
    let strTags: String?
    public let strYoutube: String
    let strIngredient1, strIngredient2, strIngredient3, strIngredient4: String
    let strIngredient5, strIngredient6: String
    let strIngredient7, strIngredient8, strIngredient9, strIngredient10: String
    let strIngredient11, strIngredient12, strIngredient13, strIngredient14: String
    let strIngredient15, strIngredient16, strIngredient17, strIngredient18: String
    let strIngredient19, strIngredient20, strMeasure1, strMeasure2: String
    let strMeasure3, strMeasure4, strMeasure5, strMeasure6: String
    let strMeasure7, strMeasure8, strMeasure9, strMeasure10: String
    let strMeasure11, strMeasure12, strMeasure13, strMeasure14: String
    let strMeasure15, strMeasure16, strMeasure17, strMeasure18: String
    let strMeasure19, strMeasure20, strSource: String
    let dateModified: JSONNull?
}


class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
