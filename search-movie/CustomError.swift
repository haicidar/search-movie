//
//  CustomError.swift
//  search-movie
//
//  Created by Haidar Rais on 22/12/24.
//

import Foundation

enum CustomError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidAPIKey
    case notFound
    case custom(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
            
        case .invalidResponse:
            return "Invalid Response"
            
        case .invalidData:
            return "Invalid data"
            
        case .invalidAPIKey:
            return "API Key not found"
            
        case .notFound:
            return "Not Found"
            
        case .custom(let error):
            return error.localizedDescription
        }
    }
}
