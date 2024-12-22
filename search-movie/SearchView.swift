//
//  ContentView.swift
//  search-movie
//
//  Created by Haidar Rais on 22/12/24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.movies == nil {
                    Text("Discover your next favorite movie!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    List(viewModel.movies ?? [], id: \.imdbID) { movie in
                        HStack {
                            AsyncImage(url: URL(string: movie.poster ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(.rect)
                            } placeholder: {
                                Rectangle()
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 60, height: 80)
                            
                            VStack(alignment: .leading) {
                                Text(movie.title?.capitalized ?? "")
                                    .font(.headline)
                                Text("\(movie.type?.rawValue.capitalized ?? "") • \(movie.year ?? "")")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .listRowInsets(EdgeInsets())
                    .background(Color.white)
                    .navigationTitle("Search Movie")
                }
                
                TextField("Search Movie", text: $viewModel.search)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
            }
        }
    }
}

#Preview {
    SearchView()
}
