//
//  MovieDetailsView.swift
//  CineHub
//
//  Created by Raul Mena on 5/13/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailsView: View {
    @ObservedObject var model: MovieDetailsModel
    
    var body: some View {
        ScrollView() {
            PosterImage()
            HStack(alignment: .top) {
                ThumbImage()
                    .offset(y: -60)
                TitleText()
                    .padding()
                Spacer()
            }
            .padding(.leading, 30)
                        
            VStack(alignment: .leading, spacing: 8) {
                GenresText()
                ReleaseDateText()
                DirectorText()
                OverviewText()
                    .padding(.top)
            }
            .offset(y: -45)
            .padding(.leading, 30)
            .padding(.trailing)
        }
        .background(Color.black)
        .ignoresSafeArea()
        .toolbar(.hidden)
    }
    
    func TitleText() -> some View {
        Text(model.title)
            .font(AppTheme.Typography.helvetica18)
            .foregroundStyle(.white)
    }
    
    func OverviewText() -> some View {
        Text(model.overview)
            .font(AppTheme.Typography.helvetica15)
            .foregroundStyle(.white)
    }
    
    @ViewBuilder
    func GenresText() -> some View {
        if !model.genres.isEmpty {
            HStack {
                Text("Genres:")
                    .font(AppTheme.Typography.helvetica16Bold)
                Text(model.genres.joined(separator: ", "))
                    .font(AppTheme.Typography.helvetica15)
                    .foregroundStyle(.gray)
            }
            .foregroundStyle(.white)
        }
    }
    
    @ViewBuilder
    func ReleaseDateText() -> some View {
        if let date = model.releaseDate {
            HStack {
                Text("Release date:")
                    .font(AppTheme.Typography.helvetica16Bold)
                Text(formatDate(date))
                    .font(AppTheme.Typography.helvetica15)
                    .foregroundStyle(.gray)
            }
            .foregroundStyle(.white)
        }
    }
    
    @ViewBuilder
    func DirectorText() -> some View {
        if let director = model.director {
            HStack {
                Text("Director:")
                    .font(AppTheme.Typography.helvetica16Bold)
                Text(director)
                    .font(AppTheme.Typography.helvetica15)
                    .foregroundStyle(.gray)
            }
            .foregroundStyle(.white)
        }
    }
    
    func PosterImage() -> some View {
        GeometryReader { geometry in
            WebImage(url: URL(string: "https://image.tmdb.org/t/p/w1280/\(model.backdropPath ?? model.posterPath)")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFill()
            } placeholder: {
                ShimmerView()
            }
            .frame(width: StretchyHeaderGeometry.getWidth(geometry), height: StretchyHeaderGeometry.getHeight(geometry))
            .clipped()
            .offset(x: StretchyHeaderGeometry.getXOffset(geometry), y: StretchyHeaderGeometry.getYOffset(geometry))
        }
        .frame(height: 300)
    }
    
    func ThumbImage() -> some View {
        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w300/\(model.posterPath)")) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFill()
        } placeholder: {
            ShimmerView()
        }
        .frame(width: 110, height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"  // Set the date format
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
}

#Preview {
    MovieDetailsView(model: .preview)
}
