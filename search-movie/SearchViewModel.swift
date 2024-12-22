//
//  SearchViewModel.swift
//  search-movie
//
//  Created by Haidar Rais on 22/12/24.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var movies: [Movie]?
    @Published var search: String = ""
    @Published var page: Int = 1
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        $search
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                Task {
                    await self?.searchMovie()
                }
            }
            .store(in: &cancellables)
    }
    
    func searchMovie()  async {
        let params: [String: String] = ["s": search, "page": String(page)]
        do {
            self.movies = try await RemoteDataSource.getSearchData(with: params).search
        } catch let error {
            print(error.localizedDescription, "got an error")
        }
    }
}
