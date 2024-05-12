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
    
    private let apiClient: APIClient
    private var page = 1
    private var cancelBag: Set<AnyCancellable> = []
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        observeMovieListSelection()
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
    
    func refresh(_ list: MovieList) {
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
            getMovieList(selectedList, page: page)
        }
    }
}
