//
//  Publisher.swift
//  App
//
//  Created by MGAbouarab on 30/01/2024.
//

import Foundation
import Combine

extension Publisher where Self.Failure == Never {
    
    public func sinkOnMain(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        self
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: receiveValue)
    }
    
}
