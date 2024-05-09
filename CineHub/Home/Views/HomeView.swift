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
                }
                .refreshable {
                    model.refresh()
                }
                .padding(.top)
            }
        }
    }
}

#Preview {
    HomeView(model: .init(apiClient: .live))
}
