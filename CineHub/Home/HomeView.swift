//
//  HomeView.swift
//  CineHub
//
//  Created by Raul Mena on 5/7/24.
//

import SwiftUI
import SDWebImageSwiftUI

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
                if let title = movie.title, let posterPath = movie.poster_path {
                    MovieRow(title: title,
                             posterPath: posterPath)
                }
            }
        }
    }
}

struct MovieRow: View {
    let title: String
    let posterPath: String
    
    var body: some View {
        HStack {
            posterImage
            Text(title)
        }
    }
    
    var posterImage: some View {
        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w300/\(posterPath)"))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaledToFill()
            .frame(width: 100, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    HomeView(model: .init(apiClient: .live))
}
