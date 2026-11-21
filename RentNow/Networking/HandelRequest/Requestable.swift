//
//  Requestable.swift
//  App
//
//  Created by MGAbouarab on 21/12/2023.
//

import Foundation
import Alamofire

protocol Requestable: RequestConvertible {

    associatedtype Response: Decodable

    var server: String {get}
    var method: RequestMethod {get}
    var path: String {get}
    var headerType: RequestHeaderType {get}
    var queries: APIParameters? {get}
    var body: APIParameters? {get}
    var uploads: [UploadData]? {get}
    var encoding: RequestEncoding {get}
    var decoder: ResponseDecoder {get}
    var timeoutInterval: TimeInterval? {get}

}
extension Requestable {
    var timeoutInterval: TimeInterval? { nil }
    func asURLRequest() throws -> URLRequest {
        
        //MARK: - URL -
        var urlRequest = URLRequest(url: try server.asURL().appendingPathComponent(path))
        if let timeoutInterval { urlRequest.timeoutInterval = timeoutInterval }
        
        // https://www.google.com/login
        
        //MARK: - HTTTP Method -
        urlRequest.httpMethod = method.rawValue
        
        //MARK: - Common Headers -
        for header in headerType.header {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        //MARK: - Parameters -
        if let queries = queries?.compactMapValues({$0}) {
            urlRequest = try URLRequestEncoding.queryString.encode(urlRequest, with: queries)
        }
        if let body = body?.compactMapValues({$0}) {
            if encoding == .json {
                urlRequest = try JSONRequestEncoding.default.encode(urlRequest, with: body)
            }
        }
        
        return urlRequest
    }
}
