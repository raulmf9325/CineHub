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
    @State private var selection: String?
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10, alignment: .top),
        GridItem(.flexible(), spacing: 10, alignment: .top),
        GridItem(.flexible(), spacing: 10, alignment: .top)
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            VStack {
                MovieCategoryDown()
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
                    model.refresh()
                }
                .padding(.top)
            }
        }
    }
    
    func MovieCategoryDown() -> some View {
        DropDownView(hint: "",
                     options: ["Now Playing", "Popular", "Top Rated", "Upcoming"],
                     background: .black,
                     selection: $selection)
    }
}

#Preview {
    HomeView(model: .init(apiClient: .live))
}
