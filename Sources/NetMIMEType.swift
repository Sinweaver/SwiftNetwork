//
//  NetMIMEType.swift
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

public enum NetMIMEType: String {
    case json = "application/json"
    case textJSON = "text/json"
    case png = "image/png"
    case jpeg = "image/jpeg"
    case html = "text/html"
    case text = "text/plain"
    case mp4 = "video/mp4"
    case xMpeg = "application/x-mpegURL"
    case form = "multipart/form-data"
    case formURL = "application/x-www-form-urlencoded"
    
    case aac = "audio/aac"
    case avi = "video/x-msvideo"
    case bin = "application/octet-stream"
    case bmp = "image/bmp"
    case csv = "text/csv"
    case gif = "image/gif"
    case ico = "image/x-icon"
    case ics = "text/calendar"
    case js = "application/javascript"
    case mpeg = "video/mpeg"
    case mpkg = "application/vnd.apple.installer+xml"
    case ogx = "application/ogg"
    case pdf = "application/pdf"
    case pkcs7 = "application/pkcs7-mime"
    case plist = "application/x-plist"
    case rar = "application/x-rar-compressed"
    case rtf = "application/rtf"
    case svg = "image/svg+xml"
    case tar = "application/x-tar"
    case tiff = "image/tiff"
    case ttf = "font/ttf"
    case wav = "audio/x-wav"
    case weba = "audio/webm"
    case webm = "video/webm"
    case webp = "image/webp"
    case wildcard = "*/*"
    case xhtml = "application/xhtml+xml"
    case xml = "application/xml"
    case zip = "application/zip"
}
