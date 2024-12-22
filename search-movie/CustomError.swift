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
            return "Invalid API Key"
            
        case .custom(let error):
            return error.localizedDescription
        }
    }
}
