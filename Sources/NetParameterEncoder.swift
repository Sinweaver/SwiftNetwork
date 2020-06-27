//
//  NetParameterEncoder.swift
//  SwiftNetwork
//
//  The MIT License (MIT)
//
//  Copyright (c) 2019 Alexander Borovikov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

public protocol NetParameterEncoderProtocol {
    func encode(parameters: [String : Any]?) -> String?
}

internal class NetXFormParameterEncoder: NetParameterEncoderProtocol {
    
    public func encode(parameters: [String : Any]?) -> String? {
        guard let parameters: [String : Any] = parameters else { return nil }
        
        return queryComponents(parameters: parameters)
    }
    
    internal func queryComponents(parameters: [String : Any], withAllowedCharacters
        allowedCharacters: CharacterSet? = nil) -> String {
        
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            if let value = parameters[key] {
                components += getNextQueryComponents(fromKey: key, value: value)
            }
        }
        
        var result: [String] = []
        
        if let allowedCharacters = allowedCharacters {
            result = components.map {
                "\($0)=\($1.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? $1)"
            }
        }
        else {
            result = components.map { "\($0)=\($1)" }
        }
        
        return result.joined(separator: "&")
    }
    
    internal func getNextQueryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += getNextQueryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        }
        else if let array = value as? [Any] {
            for value in array {
                components += getNextQueryComponents(fromKey: "\(key)[]", value: value)
            }
        }
        else {
            components.append((key, "\(value)"))
        }
        
        return components
    }
}

internal class NetURLParameterEncoder: NetXFormParameterEncoder {
    fileprivate var allowedCharacters: CharacterSet
    
    init(characters: CharacterSet) {
        self.allowedCharacters = characters
    }
    
    public override func encode(parameters: [String : Any]?) -> String? {
        guard let parameters = parameters else { return nil }
        
        let query: String = queryComponents(
            parameters: parameters, withAllowedCharacters: allowedCharacters)
        
        return query.isEmpty ? nil : "?\(query)"
    }
}

public class NetJSONParameterEncoder {
    public func encode<T: Encodable>(parameters: T?) -> Data? {
        guard let parameters: T = parameters else { return nil }
        
        let data = try? JSONEncoder().encode(parameters)

        return data
    }
    
    public func encode(parameters: [String: Any]?) -> Data? {
        guard let parameters: [String: Any] = parameters else { return nil }
        
        return try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    }
}
