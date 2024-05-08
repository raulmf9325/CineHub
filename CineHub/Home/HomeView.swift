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
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10, alignment: .top),
        GridItem(.flexible(), spacing: 10, alignment: .top),
        GridItem(.flexible(), spacing: 10, alignment: .top)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(model.movies) { movie in
                    if let title = movie.title, let posterPath = movie.poster_path {
                        MovieRow(title: title,
                                 posterPath: posterPath)
                    }
                }
                
            }
            .padding(.horizontal)
        }
        .background(Color.black)
    }
}

struct MovieRow: View {
    let title: String
    let posterPath: String
    
    var body: some View {
        VStack {
            posterImage
            Text(title)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.white)
                .font(.custom("HelveticaNeue", size: 12))
        }
    }
    
    var posterImage: some View {
        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w300/\(posterPath)")) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFill()
                .frame(width: 90, height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } placeholder: {
            ShimmerView()
                .frame(width: 90, height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    struct ShimmerView: View {
        @State private var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
        @State private var endPoint: UnitPoint = .init(x: 0, y: -0.2)
        
        private var gradientColors = [Color.gray.opacity(0.2), Color.white.opacity(0.2), Color.gray.opacity(0.2)]
        
        var body: some View {
            LinearGradient(colors: gradientColors, startPoint: startPoint, endPoint: endPoint)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                        startPoint = .init(x: 1, y: 1)
                        endPoint = .init(x: 2.2, y: 2.2)
                    }
                }
        }
    }
}

#Preview {
    HomeView(model: .init(apiClient: .live))
}
