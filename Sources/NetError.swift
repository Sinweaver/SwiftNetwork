//
//  NetError.swift
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

public struct NetError {
    public static let errorDomain: String = "NetErrorDomain"
    
    fileprivate static func errorWith(errorString: String, errorCode: Int) -> NSError {

        let userInfo: [String : String] = [
            NSLocalizedDescriptionKey : errorString
        ]

        return NSError(domain: errorDomain, code: errorCode, userInfo: userInfo)
    }
}

extension NetError {
    public static func unknown() -> NSError {
        return errorWith(errorString: "unknown", errorCode: -1)
    }
    
    public static func invalidHTTPRequest() -> NSError {
        return errorWith(errorString: "Invalid HTTP request", errorCode: -1)
    }
    
    public static func invalidHTTPResponse() -> NSError {
        return errorWith(errorString: "Invalid HTTP response", errorCode: -1)
    }
    
    public static func badResponseStatusCode(code: Int) -> NSError {
        return errorWith(errorString: "Bad response code", errorCode: code)
    }
    
    public static func unsupportedDataType() -> NSError {
        return errorWith(errorString: "Unsupported data type", errorCode: -1)
    }
    
    public static func failedToDeserializeJSON() -> NSError {
        return errorWith(errorString: "Failed to deserialize JSON", errorCode: -1)
    }
}
