//
//  NetRequestResponse.swift
//  SwiftNetwork
//
//  The MIT License (MIT)
//
//  Copyright (c) 2020 Alexander Borovikov
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

public class NetRequestResponse<T: Decodable> {
    
    // MARK: - Properties
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    public let data: Data?
    public let result: T?
    public let error: NSError?
    
    public var decodingError: DecodingError? {
        return error as? DecodingError
    }
    
    // MARK: - Lifecycle
    public init(request: URLRequest?,
                response: HTTPURLResponse?,
                data: Data?,
                result: T?,
                error: NSError?) {
        
        self.request = request
        self.response = response
        self.data = data
        self.result = result
        self.error = error
    }
    
    // MARK: - Public Methods
    public var description: String {
        return "\(String(describing: result))"
    }
    
    public var debugDescription: String {
        
        var resultString = ""
        
        if let request = request {
            resultString += "[Request]: \(request.httpMethod ?? "") \(request.debugDescription)\n"
            
            for (key,value) in request.allHTTPHeaderFields ?? [:] {
                resultString += "\(key): \(value) \n"
            }
            
            if let httpBody = request.httpBody {
                if let dataString = String(data: httpBody, encoding: String.Encoding.utf8) {
                    resultString += "[HTTPBody]: \(dataString)\n"
                }
            }
        }
        
        if let response = response {
            resultString += "[Response]: \(response)\n"
            
            if let data = data,
                let dataString = String(data: data, encoding: String.Encoding.utf8) {
                
                resultString += "[Response Body]: \(dataString)\n"
            }
        }
        
        if let error: NSError = error {
            resultString += "[Error]: \(error.description)\n"
        }
        
        return resultString
    }
}

