//
//  HomeModel.swift
//  CineHub
//
//  Created by Raul Mena on 5/7/24.
//

import Combine
import SwiftUI
import IdentifiedCollections

@MainActor
class HomeModel: ObservableObject {
    @Published var movies: IdentifiedArrayOf<Movie> = []
    @Published var selectedList: MovieList = .nowPlaying
    @Published var onError = false
    
    @Published var movieSearchQuery = ""
    @Published var isSearchingMovie = false
    
    private let apiClient: APIClient
    private var page = 1
    private var cancelBag: Set<AnyCancellable> = []
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        observeMovieListSelection()
        observeSearchQuery()
    }
    
    private func observeMovieListSelection() {
        $selectedList
            .removeDuplicates()
            .sink { [weak self] list in
                guard let self else { return }
                self.refresh(list)
            }
            .store(in: &cancelBag)
    }
    
    private func observeSearchQuery() {
        $isSearchingMovie
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] isSearching in
                guard let self else { return }
                if !isSearching {
                    refresh(selectedList)
                } else {
                    self.movies = []
                }
            }
            .store(in: &cancelBag)
        
        $movieSearchQuery
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self, isSearchingMovie else { return }
                
                movies = []
                
                if !query.isEmpty {
                    searchMovie(query, page: 1)
                }
            }
            .store(in: &cancelBag)
    }
    
    private func searchMovie(_ query: String, page: Int) {
        Task { @MainActor in
            do {
                onError = false
                let movies = try await apiClient.searchMovie(query, page)
                self.movies.append(contentsOf: IdentifiedArray(uniqueElements: movies))
            } catch {
                print("Error searching for movie '\(query)': \(error)")
                onError = true
            }
        }
    }
    
    private func getMovieList(_ list: MovieList, page: Int) {
        Task { @MainActor in
            do {
                onError = false
                let movies = try await apiClient.getMovieList(list, page)
                self.movies.append(contentsOf: movies)
            } catch {
                print("Error getting now playing: \(error)")
                onError = true
            }
        }
    }
    
    func onPullToRefresh() {
        guard !isSearchingMovie else { return }
        refresh(selectedList)
    }
    
    private func refresh(_ list: MovieList) {
        Task { @MainActor in
            do {
                onError = false
                page = 1
                let moviesArray = try await apiClient.getMovieList(list, 1)
                self.movies = IdentifiedArray(uniqueElements: moviesArray)
            } catch {
                onError = true
                print("Error getting now playing: \(error)")
            }
        }
    }
    
    func onMovieRowAppeared(id: Int?) {
        guard let id else { return }
        if id == movies.last?.id {
            page += 1
            
            if isSearchingMovie {
                searchMovie(movieSearchQuery, page: page)
            } else {
                getMovieList(selectedList, page: page)
            }
        }
    }
}
