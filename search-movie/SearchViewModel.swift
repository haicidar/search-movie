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
    @Published var movies: [Movie] = []
    @Published var search: String = ""
    @Published var isLoading: Bool = false
    private var page: Int = 1
    private var isLastPage: Bool = false
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        $search
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                Task {
                    self?.resetSearch()
                }
            }
            .store(in: &cancellables)
    }
    
    func resetSearch() {
        self.page = 1
        self.isLastPage = false
        Task {
            await searchMovie()
        }
    }
    
    func searchMovie()  async {
        guard !search.isEmpty, !isLoading, !isLastPage else { return }
        isLoading = true
        let params: [String: String] = ["s": search, "page": String(page)]
        do {
            let searchResult = try await RemoteDataSource.getSearchData(with: params)
            guard let movies = searchResult.search else { throw CustomError.notFound }
            if page == 1 {
                self.movies = movies
            } else {
                self.movies.append(contentsOf: movies)
            }
            if movies.count < Int(searchResult.totalResults ?? "0") ?? 0 {
                self.page += 1
            } else {
            isLastPage = true
            }
        } catch let error {
            print(error.localizedDescription, "got an error")
        }
        isLoading = false
    }
}
