//
//  Endpoint.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation
import Alamofire

struct Endpoint<T: Decodable>: Requestable {

    typealias Response = T

    let server: String

    let method: RequestMethod

    let path: String

    let queries: APIParameters?

    let body: APIParameters?

    let headerType: RequestHeaderType

    let uploads: [UploadData]?

    let encoding: RequestEncoding

    let decoder: ResponseDecoder
    let timeoutInterval: TimeInterval?
    
    
    init(
        server: String = NetworkConstants.server,
        method: RequestMethod = .get,
        path: String,
        queries: APIParameters? = nil,
        body: APIParameters? = nil,
        headerType: RequestHeaderType = .unauthorized,
        uploads: [UploadData]? = nil,
        encoding: RequestEncoding = .json,
        decoder: ResponseDecoder = DefaultJSONDecoder(),
        timeoutInterval: TimeInterval? = nil
    ) {
        self.server = server
        self.method = method
        self.path = path
        self.queries = queries
        self.body = body
        self.headerType = headerType
        self.uploads = uploads
        self.encoding = encoding
        self.decoder = decoder
        self.timeoutInterval = timeoutInterval
    }
    
}
