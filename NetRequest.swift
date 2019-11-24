//
//  Request.swift
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

public class NetRequest {
    
    public static let defaultTimeoutInterval : TimeInterval = 60.0
    
    // MARK: - Properties
    open private(set) var urlRequest: URLRequest? = nil
    fileprivate var task: URLSessionDataTask? = nil
    
    fileprivate var url: String
    fileprivate var method: NetHTTPMethod
    fileprivate var urlParameters: [String: Any]?
    fileprivate var bodyParameters: Any?
    fileprivate var parametersType: NetMIMEType
    fileprivate var allowedCharacters: CharacterSet
    fileprivate var timeoutInterval: TimeInterval
    fileprivate var headers: NetHTTPHeaders?
    
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
        
        self.url = url
        self.method = method
        self.urlParameters = urlParameters
        self.bodyParameters = bodyParameters
        self.parametersType = parametersType
        self.allowedCharacters = allowedCharacters
        self.timeoutInterval = timeoutInterval
        self.headers = headers
    }
    
    // MARK: - Public Methods
    open func start() {
        task?.resume()
    }
    
    open func pause() {
        task?.suspend()
    }
    
    open func stop() {
        task?.cancel()
    }
    
    public func executeRequestWith(session: URLSession, completionHandler:
        @escaping(_ responseData: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void) {
        
        urlRequest = makeUrlRequest()
        
        if let urlRequest: URLRequest = urlRequest {
            task = session.dataTask(with: urlRequest, completionHandler: completionHandler)
            task?.resume()
        }
        else {
            completionHandler(nil, nil, NetError.invalidHTTPRequest())
        }
    }
    
    // MARK: - Private Methods
    fileprivate func makeUrlRequest() -> URLRequest? {
        
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
        
        guard let requestUrl: URL = makeUrlWithParameters(
            urlParameters, baseUrl: url, characters: allowedCharacters) else {
                return nil
        }
        
        var request: URLRequest = URLRequest(
            url: requestUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        request.httpMethod = method.rawValue
        
        if let headers: NetHTTPHeaders = headers {
            for (key, value) in headers.allHTTPHeaderFields {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = body {
            request.httpBody = body
            
            let postLength: Int = body.count
            if postLength > 0 {
                request.setValue("\(postLength)", forHTTPHeaderField: "Content-Length")
            }
            
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue(parametersType.rawValue, forHTTPHeaderField: "Content-Type")
            }
        }
        
        return request
    }
    
    fileprivate func makeUrlWithParameters(
        _ parameters: [String : Any]?,
        baseUrl: String,
        characters: CharacterSet) -> URL? {
        
        var url = baseUrl
        
        if let encodedParameters: String = NetURLParameterEncoder(characters: characters).encode(
            parameters: parameters) {
            
            url += encodedParameters
        }
        
        return URL(string: url)
    }
}
