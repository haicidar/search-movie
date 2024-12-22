//
//  UserDefault.swift
//  search-movie
//
//  Created by Haidar Rais on 22/12/24.
//

import Foundation

enum UserDefaultsKey: String {
    case searchKeyword
    case movies
}

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    // Generic method to save a value
    func set<T>(value: T, forKey key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    // Generic method to retrieve a value
    func get<T>(forKey key: UserDefaultsKey) -> T? {
        return defaults.object(forKey: key.rawValue) as? T
    }
}
