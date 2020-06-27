//
//  NetSession.swift
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

internal class NetSession: NSObject {
    
    // MARK: - Properties
    fileprivate var acceptableStatusCodes: Range<Int> { return 200..<300 }
    
    fileprivate private(set) lazy var session : URLSession = self.makeSession()
    
    fileprivate var requests: [URLSessionTask: NetRequest] = [:]
    
    // MARK: Shared Instance
    public static let `default` : NetSession = {
        let instance = NetSession()
        return instance
    }()
    
    // MARK: - Lifecycle
    public override init() {
        super.init()
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    // MARK: - Public Methods
    public func request<T: Decodable>(
        request: NetRequestBase,
        completingOnQueue queue: DispatchQueue = .main,
        completion: @escaping(_ response: NetRequestResponse<T>) -> Void) {
        
        DispatchQueue.global(qos: .default).async { [weak self] () -> Void in
            guard let self = self else { return }
            
            request.executeRequestWith(session: self.session) {
                [weak self] (responseData: Data?, urlResponse: URLResponse?, error: Error?) in
                
                var error: NSError? = self?.validateCompletionValues(
                    data: responseData, response: urlResponse, error: error)
                var result: T? = nil
                
                if error == nil, let responseData: Data = responseData, !responseData.isEmpty {
                    do {
                        result = try JSONDecoder().decode(T.self, from: responseData)
                    }
                    catch let decodeError {
                        error = decodeError as NSError
                    }
                }
                
                let response = NetRequestResponse<T>(
                    request: request.urlRequest,
                    response: urlResponse as? HTTPURLResponse,
                    data: responseData,
                    result: result,
                    error: error)
                
                queue.async { completion(response) }
            }
        }
    }
    
    public func download<T>(
        request: NetRequestBase,
        completingOnQueue queue: DispatchQueue = .main,
        completion: @escaping(_ response: NetDownloadResponse<T>) -> Void) {
        
        DispatchQueue.global(qos: .default).async { [weak self] () -> Void in
            guard let self = self else { return }
            
            request.executeRequestWith(session: self.session) {
                [weak self] (responseData: Data?, urlResponse: URLResponse?, error: Error?) in
                
                var error: NSError? = self?.validateCompletionValues(
                    data: responseData, response: urlResponse, error: error)
                var result: T? = nil
                
                if error == nil, let responseData = responseData {
                    if T.self == Data.self {
                        result = responseData as? T
                    }
                    else if T.self == UIImage.self {
                        result = UIImage(data: responseData) as? T
                    }
                    else if T.self == String.self {
                        result = String(data: responseData, encoding: String.Encoding.utf8) as? T
                    }
                    else {
                        error = NetError.unsupportedDataType()
                    }
                }
                
                let response = NetDownloadResponse<T>(
                    request: request.urlRequest,
                    response: urlResponse as? HTTPURLResponse,
                    data: responseData,
                    result: result,
                    error: error)
                
                queue.async { completion(response) }
            }
        }
    }
    
    public func cancelAllRequests() {
        session.getAllTasks { (tasks: [URLSessionTask]) in
            tasks.forEach { $0.cancel() }
        }
    }
    
    public func resetSession() {
        session.reset { [weak self] in
            if let cookieStore = self?.session.configuration.httpCookieStorage {
                for cookie in cookieStore.cookies ?? [] {
                    cookieStore.deleteCookie(cookie)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    fileprivate func validateCompletionValues(
        data: Data?,
        response: URLResponse?,
        error: Error?) -> NSError? {
        
        if let error: Error = error {
            return error as NSError
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return NetError.invalidHTTPResponse()
        }
        
        guard acceptableStatusCodes.contains(httpResponse.statusCode) else {
            return NetError.badResponseStatusCode(code: httpResponse.statusCode)
        }
        
        return nil
    }
    
    fileprivate func makeSession() -> URLSession {
        let config = URLSessionConfiguration.default
        
        config.httpShouldSetCookies = true
        config.httpShouldUsePipelining = true
        config.allowsCellularAccess = true
        
        config.urlCache = nil
        
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
}

extension NetSession: URLSessionDelegate {
    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        let disposition: URLSession.AuthChallengeDisposition = URLSession.AuthChallengeDisposition.performDefaultHandling
        let credential: URLCredential? = nil
        
        completionHandler(disposition, credential);
    }
}
