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
    
    private let apiClient: APIClient
    private var page = 1
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        getNowPlaying(1)
    }
    
    private func getNowPlaying(_ page: Int) {
        Task { @MainActor in
            do {
                let movies = try await apiClient.getNowPlaying(page)
                self.movies.append(contentsOf: movies)
                
            } catch {
                print("Error getting now playing: \(error)")
            }
        }
    }
    
    func refresh() {
        Task { @MainActor in
            do {
                let moviesArray = try await apiClient.getNowPlaying(1).shuffled()
                self.movies = IdentifiedArray(uniqueElements: moviesArray)
            } catch {
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
