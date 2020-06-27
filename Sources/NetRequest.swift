//
//  NetRequest.swift
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

public class NetRequest: NetRequestBase {
    
    // MARK: - Properties
    fileprivate var bodyParameters: Any?
    
    // MARK: - Lifecycle
    public init(
        url: String,
        method: NetHTTPMethod = .get,
        urlParameters: [String: Any]? = nil,
        bodyParameters: Any? = nil,
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
        var body: Data? = nil
        
        if parametersType == .json {
            if let bodyDictionary: [String: Any] = bodyParameters as? [String : Any] {
                body = NetJSONParameterEncoder().encode(parameters: bodyDictionary)
            }
        }
        else if parametersType == .formURL {
            if let bodyDictionary: [String: Any] = bodyParameters as? [String : Any] {
                if let parameters: String = NetXFormParameterEncoder().encode(
                    parameters: bodyDictionary) {
                    body = Data(parameters.utf8)
                }
            }
        }
        else if parametersType == .png {
            if let bodyImage: UIImage = bodyParameters as? UIImage {
                body = bodyImage.pngData()
            }
        }
        else if parametersType == .text {
            if let bodyString: String = bodyParameters as? String {
                body = Data(bodyString.utf8)
            }
        }
        else if parametersType == .form {
            if let bodyData: Data = bodyParameters as? Data {
                body = bodyData
            }
        }
        
        return body
    }
}
