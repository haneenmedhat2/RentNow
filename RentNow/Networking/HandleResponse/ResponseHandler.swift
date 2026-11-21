//
//  ResponseHandler.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation

protocol ResponseHandler {
    func get<T: Decodable>(_ endpoint: Endpoint<T>, progress: ((_ progress: Int)-> Void)?) async throws -> T
}


struct DefaultResponseHandler: ResponseHandler {
    
    private let networkExecuter: NetworkExecuter
    
    init(networkExecuter: NetworkExecuter = DefaultNetworkExecuter()) {
        self.networkExecuter = networkExecuter
    }
    
    func get<T: Decodable>(_ endpoint: Endpoint<T>, progress: ((_ progress: Int)-> Void)? = nil) async throws -> T {
        let data = try await self.networkExecuter.execute(endpoint, progress: progress)

        // Check if response is empty before attempting to decode
        guard !data.isEmpty else {
            throw ResponseError.emptyResponse
        }

        return try  endpoint.decoder.decode(data: data)
    }
    
}
