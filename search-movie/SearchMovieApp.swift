//
//  search_movieApp.swift
//  search-movie
//
//  Created by Haidar Rais on 22/12/24.
//

import SwiftUI

@main
struct SearchMovieApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(viewModel: SearchViewModel(networkMonitor: NetworkMonitor.shared))
        }
    }
}
