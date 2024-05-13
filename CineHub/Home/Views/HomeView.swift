//
//  HomeView.swift
//  CineHub
//
//  Created by Raul Mena on 5/7/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @ObservedObject var model: HomeModel
    @State private var gridLayout: GridLayout = .three
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea(.all)
                
                VStack {
                    HeaderView(gridLayout: $gridLayout,
                               selection: $model.selectedList.toStringBinding(),
                               text: $model.movieSearchQuery,
                               isSearching: $model.isSearchingMovie)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 30) {
                            ForEach(model.movies) { movie in
                                NavigationLink(value: movie) {
                                    MovieRow(title: movie.title,
                                             posterPath: movie.poster_path,
                                             imageWidth: gridLayout == .three ? 90 : 150,
                                             imageHeight: gridLayout == .three ? 110 : 200)
                                    .onAppear {
                                        model.onMovieRowAppeared(id: movie.id)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .navigationDestination(for: Movie.self) { movie in
                            MovieDetailsView(model: MovieDetailsModel(movieId: movie.id,
                                                                      title: movie.title,
                                                                      overview: movie.overview,
                                                                      posterPath: movie.poster_path, backdropPath: movie.backdrop_path, releaseDate: movie.release_date, apiClient: .live))
                        }
                        
                        if model.onError {
                            VStack(alignment: .center, spacing: 5) {
                                Text("An error occurred 😢")
                                    .foregroundStyle(Color.white)
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                                
                                Text("Please pull to refresh")
                                    .foregroundStyle(Color.white)
                            }
                            .padding(.vertical)
                        }
                    }
                    .refreshable {
                        model.refresh(model.selectedList)
                    }
                    .padding(.top)
                }
            }
        }
    }
    
    var columns: [GridItem] {
        switch gridLayout {
        case .two:
            return .two
        case .three:
            return .three
        }
    }
}

private extension Array where Element == GridItem {
    static let two: [GridItem] = [
        GridItem(.flexible(), spacing: 10, alignment: .top),
        GridItem(.flexible(), spacing: 10, alignment: .top)
    ]
    static let three: [GridItem] = [
        GridItem(.flexible(), spacing: 10, alignment: .top),
        GridItem(.flexible(), spacing: 10, alignment: .top),
        GridItem(.flexible(), spacing: 10, alignment: .top)
    ]
}

#Preview {
    HomeView(model: .init(apiClient: .live))
}
