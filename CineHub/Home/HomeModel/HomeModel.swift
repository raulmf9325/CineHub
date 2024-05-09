//
//  HomeModel.swift
//  CineHub
//
//  Created by Raul Mena on 5/7/24.
//

import SwiftUI
import IdentifiedCollections

@MainActor
class HomeModel: ObservableObject {
    @Published var movies: IdentifiedArrayOf<Movie> = []
    @Published var onError = false
    
    private let apiClient: APIClient
    private var page = 1
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        refresh()
    }
    
    private func getNowPlaying(_ page: Int) {
        Task { @MainActor in
            do {
                onError = false
                let movies = try await apiClient.getNowPlaying(page)
                self.movies.append(contentsOf: movies)
            } catch {
                print("Error getting now playing: \(error)")
                onError = true
            }
        }
    }
    
    func refresh() {
        Task { @MainActor in
            do {
                onError = false
                page = 1
                let moviesArray = try await apiClient.getNowPlaying(1).shuffled()
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
            getNowPlaying(page)
        }
    }
}
