//
//  RemoteDataSource.swift
//  search-movie
//
//  Created by Haidar Rais on 22/12/24.
//

import Foundation

final class RemoteDataSource {
    
    static func getSearchData(with params: [String: String] = [:]) async throws -> Search {
        var urlComponents = URLComponents(string: "https://www.omdbapi.com")
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            throw CustomError.invalidAPIKey
        }
        
        var queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        queryItems.append(URLQueryItem(name: "apiKey", value: apiKey))
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            throw CustomError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw CustomError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Search.self, from: data)
        } catch {
            throw CustomError.invalidData
        }
    }
}

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
