//
//  ContentView.swift
//  search-movie
//
//  Created by Haidar Rais on 22/12/24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.movies.isEmpty {
                    Text(viewModel.descriptionTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .transition(.push(from: .top))
                        .padding(.horizontal)
                } else {
                    List(viewModel.movies, id: \.id) { movie in
                        HStack {
                            if let validatedUrl = viewModel.validatedURL(from: movie.poster ?? "") {
                                AsyncImage(url: validatedUrl) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(.rect)
                                } placeholder: {
                                    Rectangle()
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 90, height: 120)
                                .shimmer(when: .constant(viewModel.isLoading))
                            } else {
                                Image("EmptyPoster")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.gray)
                                    .opacity(0.5)
                                    .frame(width: 90, height: 120)
                                    .shimmer(when: .constant(viewModel.isLoading))
                            }
                            
                            VStack(alignment: .leading) {
                                Text(movie.title?.capitalized ?? "")
                                    .font(.headline)
                                    .shimmer(when: .constant(viewModel.isLoading))
                                Text("\(movie.type?.rawValue.capitalized ?? "") • \(movie.year ?? "")")
                                    .font(.subheadline)
                                    .shimmer(when: .constant(viewModel.isLoading))
                            }
                        }
                        .onAppear {
                            if movie == viewModel.movies.last {
                                Task {
                                    await viewModel.searchMovie()
                                }
                            }
                        }
                    }
                    .refreshable {
                        viewModel.resetSearch()
                    }
                    .listStyle(.plain)
                    .listRowInsets(EdgeInsets())
                    .background(Color.white)
                    .navigationTitle("Search Movie")
                    .transition(.opacity)
                }
                
                TextField("Search Movie", text: $viewModel.search)
                    .onSubmit {
                        viewModel.resetSearch()
                    }
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
                    .transition(.slide)
            }
            .alert(isPresented: $viewModel.isShowingAlert) {
                return Alert(
                    title: Text("Error"),
                    message: Text(viewModel.error?.errorDescription ?? "")
                )
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.movies.isEmpty)
        }
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(networkMonitor: NetworkMonitor.shared))
}
