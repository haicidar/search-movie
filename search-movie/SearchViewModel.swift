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
    @Published var descriptionTitle: String = ""
    @Published var error: CustomError?
    @Published var isShowingAlert: Bool = false
    @Published var isConnected: Bool = false
    
    private var networkMonitor: NetworkMonitoring
    private let defaultDescriptionTitle: String = "Discover your next favorite movie!"
    private var page: Int = 1
    private var isLastPage: Bool = false
    
    private var cancellables = Set<AnyCancellable>()

    init(networkMonitor: NetworkMonitoring) {
        self.networkMonitor = networkMonitor
        
        observeNetwork()
        
        descriptionTitle = defaultDescriptionTitle
        
        restoreSearchHistory()
        
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
    
    private func observeNetwork() {
        networkMonitor.startMonitoring()
        isConnected = networkMonitor.isConnected
    }
    
    private func resetSearch() {
        self.page = 1
        self.isLastPage = false
        Task {
            await searchMovie()
        }
    }
    
    private func storeSearchHistory() {
        UserDefaultsManager.shared.set(value: search, forKey: .searchKeyword)
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(movies)
            UserDefaultsManager.shared.set(value: data, forKey: .movies)
        } catch let error {
            self.error = .custom(error: error)
            self.isShowingAlert = true
        }
    }
    
    private func restoreSearchHistory() {
        guard let search = UserDefaultsManager.shared.get(forKey: .searchKeyword) as String? else { return }
        self.search = search
        guard let storedMovies = UserDefaultsManager.shared.get(forKey: .movies) as Data? else { return }
        do {
            let decoder = PropertyListDecoder()
            let movies = try decoder.decode([Movie].self, from: storedMovies)
            self.movies = movies
        } catch let error {
            self.error = .custom(error: error)
            self.isShowingAlert = true
        }
    }
    
    func validatedURL(from string: String) -> URL? {
        guard !string.isEmpty, string != "N/A" else {
            return nil
        }
        guard let url = URL(string: string) else {
            return nil
        }
        guard let scheme = url.scheme?.lowercased(), ["http", "https"].contains(scheme) else {
            return nil
        }
        return url
    }
    
    func searchMovie()  async {
        observeNetwork()
        guard !search.isEmpty, !isLoading, !isLastPage, isConnected else { return }
        isLoading = true
        let params: [String: String] = ["s": search, "page": String(page)]
        do {
            let searchResult = try await RemoteDataSource.getSearchData(with: params)
            guard let movies = searchResult.search else { throw CustomError.notFound }
            if page == 1 {
                self.movies = movies
                storeSearchHistory()
            } else {
                self.movies.append(contentsOf: movies)
            }
            
            let totalMoviesFetched = self.movies.count
            let totalMoviesAvailable = Int(searchResult.totalResults ?? "0") ?? 0

            if totalMoviesFetched < totalMoviesAvailable {
                self.page += 1
            } else {
                isLastPage = true
            }

        } catch let error as CustomError {
            switch error {
            case .notFound:
                self.movies = []
                self.descriptionTitle = "Empty popcorn bucket 🍿 Try a new search!"
            default:
                self.error = error
                self.isShowingAlert = true
            }
        } catch {
            self.error = .custom(error: error)
            self.isShowingAlert = true
        }
        isLoading = false
    }
}
