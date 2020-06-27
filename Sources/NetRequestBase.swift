//
//  NetRequestBase.swift
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

public class NetRequestBase {
    
    public static let defaultTimeoutInterval : TimeInterval = 60.0
    
    // MARK: - Properties
    open private(set) var urlRequest: URLRequest? = nil
    fileprivate var task: URLSessionDataTask? = nil
    
    internal private(set) var url: String
    internal private(set) var method: NetHTTPMethod
    internal private(set) var urlParameters: [String: Any]?
    internal private(set) var parametersType: NetMIMEType
    internal private(set) var allowedCharacters: CharacterSet
    internal private(set) var timeoutInterval: TimeInterval
    internal private(set) var headers: NetHTTPHeaders?
    
    // MARK: - Lifecycle
    public init(
        url: String,
        method: NetHTTPMethod = .get,
        urlParameters: [String: Any]? = nil,
        parametersType: NetMIMEType = .formURL,
        allowedCharacters: CharacterSet = .urlQueryParametersAllowed,
        timeoutInterval: TimeInterval = defaultTimeoutInterval,
        headers: NetHTTPHeaders? = nil) {
        
        self.url = url
        self.method = method
        self.urlParameters = urlParameters
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
    
    // MARK: - Internal Methods
    internal func getHttpBody() -> Data? {
        return nil
    }
    
    // MARK: - Private Methods
    fileprivate func makeUrlRequest() -> URLRequest? {
        
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
        
        if let body: Data = getHttpBody() {
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
