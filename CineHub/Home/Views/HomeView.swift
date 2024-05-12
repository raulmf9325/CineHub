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
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            VStack {
                Header
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 30) {
                        ForEach(model.movies) { movie in
                            MovieRow(title: movie.title, 
                                     posterPath: movie.poster_path,
                                     imageWidth: gridLayout == .three ? 90 : 150,
                                     imageHeight: gridLayout == .three ? 110 : 200)
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
    
    var Header: some View {
        HStack {
            Button(action: {
                    switch gridLayout {
                    case .two:
                        gridLayout = .three
                    case .three:
                        gridLayout = .two
                    }
            }, label: {
                Image(systemName: gridLayout == .three ? "square.grid.3x3.fill" : "square.grid.2x2.fill")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .animation(nil, value: gridLayout)
            })
            .padding(.leading, 40)
            
            Spacer()
            
            MovieListDropDown()
            
            Spacer()
        }
        .zIndex(2)
    }
    
    var columns: [GridItem] {
        switch gridLayout {
        case .two:
            return .two
        case .three:
            return .three
        }
    }
    
    func MovieListDropDown() -> some View {
        DropDownView(options: MovieList.allCases.map(\.rawValue),
                     background: .black,
                     selection: $model.selectedList.toStringBinding())
    }
}

extension HomeView {
    enum GridLayout {
        case two
        case three
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
