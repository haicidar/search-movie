//
//  SearchModel.swift
//  search-movie
//
//  Created by Haidar Rais on 22/12/24.
//

import Foundation

// MARK: - Search
struct Search: Codable {
    let search: [Movie]?
    let totalResults, response: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Movie
struct Movie: Codable {
    let title, year, imdbID: String?
    let type: TypeEnum?
    let poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

enum TypeEnum: String, Codable {
    case movie
    case series
    case episode
}
