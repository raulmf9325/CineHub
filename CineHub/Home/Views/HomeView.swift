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
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10, alignment: .top),
        GridItem(.flexible(), spacing: 10, alignment: .top),
        GridItem(.flexible(), spacing: 10, alignment: .top)
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            VStack {
                MovieListDown()
                    .zIndex(1)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 30) {
                        ForEach(model.movies) { movie in
                            MovieRow(title: movie.title, posterPath: movie.poster_path)
                                .onAppear {
                                    model.onMovieRowAppeared(id: movie.id)
                                }
                        }
                    }
                    .padding(.horizontal)
                    
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
    
    func MovieListDown() -> some View {
        DropDownView(options: MovieList.allCases.map(\.rawValue),
                     background: .black,
                     selection: $model.selectedList.toStringBinding())
    }
}

#Preview {
    HomeView(model: .init(apiClient: .live))
}
