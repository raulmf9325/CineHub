//
//  HomeView.swift
//  CineHub
//
//  Created by Raul Mena on 5/7/24.
//

import SwiftUI

@MainActor
class HomeModel: ObservableObject {
    @Published var movies = [Movie]()
    
    private let apiClient: APIClient
    private var page = 1
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        getNowPlaying()
    }
    
    private func getNowPlaying() {
        Task { @MainActor in
            do {
                self.movies = try await apiClient.getNowPlaying(page)
            } catch {
                print("Error getting now playing: \(error)")
            }
        }
    }
}

struct HomeView: View {
    @ObservedObject var model: HomeModel
    
    var body: some View {
        List {
            ForEach(model.movies) { movie in
                Text(movie.title ?? "Unknown title")
            }
        }
    }
}

#Preview {
    HomeView(model: .init(apiClient: .live))
}
