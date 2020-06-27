//
//  NetRequestEncodable.swift
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

import UIKit
import Foundation

public class NetRequestEncodable<T: Encodable>: NetRequestBase {
    
    // MARK: - Properties
    fileprivate var bodyParameters: T?
    
    // MARK: - Lifecycle
    public init(
        url: String,
        method: NetHTTPMethod = .get,
        urlParameters: [String: Any]? = nil,
        bodyParameters: T? = nil,
        parametersType: NetMIMEType = .formURL,
        allowedCharacters: CharacterSet = .urlQueryParametersAllowed,
        timeoutInterval: TimeInterval = defaultTimeoutInterval,
        headers: NetHTTPHeaders? = nil) {
        
        super.init(
            url: url,
            method: method,
            urlParameters: urlParameters,
            parametersType: parametersType,
            allowedCharacters: allowedCharacters,
            timeoutInterval: timeoutInterval,
            headers: headers)
        
        self.bodyParameters = bodyParameters
    }
    
    // MARK: - Internal Methods
    internal override func getHttpBody() -> Data? {
        return NetJSONParameterEncoder().encode(parameters: bodyParameters)
    }
}
