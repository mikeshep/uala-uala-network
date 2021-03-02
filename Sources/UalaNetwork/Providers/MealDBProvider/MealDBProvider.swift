//
//  MealDBProvider.swift
//  
//
//  Created by Miguel Angel Olmedo Perez on 02/03/21.
//

import Foundation
import Moya
import RxMoya
import RxSwift
import Alamofire
import SystemConfiguration


class MealDBProvider {

    private let provider: MoyaProvider<MealDBService>
    fileprivate let reachability: SCNetworkReachability? = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    
    public init() {
        let provider = MoyaProvider<MealDBService>()
        self.provider = provider
    }
    
    private func request(_ target: MealDBService) -> Single<(JSON, Response)> {
        return provider.rx.request(target).parseToJSON()
    }
    
    public func request<D: Decodable>(_ target: MealDBService) -> Single<D> {
        return request(target).map(D.self)
    }
}

//MARK: - Single<Response> extensions
private extension Single where TraitType == SingleTrait, Element == Response {
    func parseToJSON() -> Single<(JSON, Response)> {
        return flatMap { response in
            guard let json = try response.mapJSON() as? JSON else { throw NetworkError.malformedJson }
            return .just((json, response))
        }
    }
}

//MARK: - Single<JSON, Response> extensions
private extension Single where TraitType == SingleTrait, Element == (JSON, Response) {
    func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder()) -> Single<D> {
        return flatMap { json, response in
            return .just(try json.map(D.self, atKeyPath: keyPath))
        }
    }
    
    func extractJSON() -> Single<JSON> {
        return map({$0.0})
    }
}

extension Dictionary where Key == String, Value: Any {
    func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil) throws -> D {
        let jsonData: Data
        let decoder = JSONDecoder()
        
        if let keyPath = keyPath {
            guard let jsonObject = self[keyPath: KeyPath(keyPath)] else { throw NetworkError.malformedJson }
            
            if let data = try serializeToData(jsonObject) {
                jsonData = data
            } else {
                let wrappedJsonObject = ["value": jsonObject]
                guard let data = try serializeToData(wrappedJsonObject) else { throw NetworkError.malformedJson }
                
                do {
                    return try decoder.decode(DecodableWrapper<D>.self, from: data).value
                } catch let error {
                    throw NetworkError.mismatchEncoding(swiftError: error, responseJSON: self)
                }
            }
        } else if let data = try serializeToData(self) {
            jsonData = data
        } else {
            throw NetworkError.malformedJson
        }
        
        do {
            return try decoder.decode(D.self, from: jsonData)
        } catch let error {
            throw NetworkError.mismatchEncoding(swiftError: error, responseJSON: self)
        }
    }
}

private extension Dictionary where Key == String, Value: Any {
    private struct DecodableWrapper<D: Decodable>: Decodable {
        let value: D
    }
}

private func serializeToData(_ object: Any) throws -> Data? {
    guard JSONSerialization.isValidJSONObject(object) else { return nil }
    do {
        return try JSONSerialization.data(withJSONObject: object)
    } catch {
        throw NetworkError.malformedJson
    }
}

// MARK: - KeyPath

//Credits for this dictionary extension for Ole Begemann => https://oleb.net/blog/2017/01/dictionary-key-paths/
struct KeyPath {
    var segments: [String]
    
    var isEmpty: Bool { return segments.isEmpty }
    var path: String {
        return segments.joined(separator: ".")
    }
    
    func headAndTail() -> (head: String, tail: KeyPath)? {
        guard !isEmpty else { return nil }
        var tail = segments
        let head = tail.removeFirst()
        return (head, KeyPath(segments: tail))
    }
}

extension KeyPath {
    init(_ string: String) {
        segments = string.components(separatedBy: ".")
    }
}

extension KeyPath: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(value)
    }
    
    init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
    
    init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
}

extension Dictionary where Key == String {
    subscript(keyPath keyPath: KeyPath) -> Any? {
        get {
            switch keyPath.headAndTail() {
            case nil:
                // key path is empty.
                return nil
            case let (head, remainingKeyPath)? where remainingKeyPath.isEmpty:
                // Reached the end of the key path.
                return self[head]
            case let (head, remainingKeyPath)?:
                // Key path has a tail we need to traverse.
                switch self[head] {
                case let nestedDict as [Key: Any]:
                    // Next nest level is a dictionary.
                    // Start over with remaining key path.
                    return nestedDict[keyPath: remainingKeyPath]
                default:
                    // Next nest level isn't a dictionary.
                    // Invalid key path, abort.
                    return nil
                }
            }
        }
    }
    
    func value<T>(forKeyPath path: KeyPath, ofClass: T.Type) -> T? {
        return self[keyPath: path] as? T
    }
}
