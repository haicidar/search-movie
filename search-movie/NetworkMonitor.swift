//
//  NetworkMonitor.swift
//  search-movie
//
//  Created by Haidar Rais on 22/12/24.
//

import Foundation
import Network

protocol NetworkMonitoring {
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

final class NetworkMonitor: NetworkMonitoring {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    private(set) var isConnected: Bool = false
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
