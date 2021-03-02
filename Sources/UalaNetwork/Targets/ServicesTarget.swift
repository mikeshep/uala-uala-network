//
//  File.swift
//  
//
//  Created by Miguel Angel Olmedo Perez on 02/03/21.
//

import Moya
import Foundation

// MARK: - TargetType Protocol Implementation
extension MealDBService: TargetType {
    var baseURL: URL { return URL(string: "https://www.themealdb.com")! }
    var path: String {
        switch self {
        case .search:
            return "/api/json/v1/1/search.php"
        case .detail:
            return "/api/json/v1/1/lookup.php"
        case .random:
            return "/api/json/v1/1/random.php"
        }
    }

    var method: Moya.Method {
        switch self {
        case .search, .detail, .random:
            return .get
        }
    }
    var task: Task {
        switch self {
        case let .search(s):
            return .requestParameters(parameters: ["s": s], encoding: URLEncoding.queryString)
        case let .detail(id):
            return .requestParameters(parameters: ["i": id], encoding: URLEncoding.queryString)
        case .random:
            return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .search, .detail, .random:
            return "".utf8Encoded
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
