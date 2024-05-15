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
    @Environment(\.dismiss) var dismiss
    @State private var isShowingSheet: Sheet?
    
    var body: some View {
        ZStack {
            ScrollView() {
                PosterImage()
                HStack(alignment: .top) {
                    ThumbImage()
                        .offset(y: -60)
                    VStack(alignment: .leading, spacing: 10) {
                        TitleText()
                        HStack(spacing: 20) {
                            RuntimeText()
                            RottenTomatoesScore()
                        }
                    }
                    .padding()
                    Spacer()
                }
                .padding(.leading, 30)
                
                VStack(alignment: .leading, spacing: 8) {
                    GenresText()
                    ReleaseDateText()
                    DirectorText()
                    WatchTrailerViewButton()
                        .padding(.top, 1)
                    OverviewText()
                        .padding(.top)
                    CastView()
                        .padding(.top)
                }
                .offset(y: -45)
                .padding(.leading, 30)
                .padding(.trailing)
            }
            .ignoresSafeArea()
            
            VStack {
                ToolBar()
                Spacer()
            }
            .padding(.horizontal, 25)
            .toolbar(.hidden)
        }
        .background(Color.black.ignoresSafeArea())
        .fullScreenCover(item: $isShowingSheet) { sheet in
            switch sheet {
            case .movieTrailer(let urlString):
                PlayTrailerView(urlString: urlString)
            }
        }
    }
    
    enum Sheet: Identifiable {
        case movieTrailer(String)
        
        var id: String {
            switch self {
            case .movieTrailer(let urlString):
                return urlString
            }
        }
    }
    
    func ToolBar() -> some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Circle().fill(Color.black.opacity(0.4))
                    .frame(width: 35)
                    .overlay(
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundStyle(.white)
                    )
                
                Spacer()
            }
        }
    }
    
    func TitleText() -> some View {
        Text(model.title)
            .font(AppTheme.Typography.helvetica18)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    func RuntimeText() -> some View {
        if let runtime = model.runtime {
            Text(runtime)
                .font(AppTheme.Typography.helvetica15)
                .foregroundStyle(.gray)
        }
    }
    
    @ViewBuilder
    func RottenTomatoesScore() -> some View {
        if let score = model.rottenTomatoesScore {
            HStack {
                Image("Rotten_Tomatoes")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                Text(score)
                    .font(AppTheme.Typography.helvetica15)
                    .foregroundStyle(.gray)
            }
        }
    }
    
    @ViewBuilder
    func OverviewText() -> some View {
        if !model.overview.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("Overview")
                    .font(AppTheme.Typography.helvetica16)
                    .bold()
                    .foregroundStyle(.white)
                Text(model.overview)
                    .font(AppTheme.Typography.helvetica15)
                    .foregroundStyle(.gray)
            }
        }
    }
    
    @ViewBuilder
    func GenresText() -> some View {
        if !model.genres.isEmpty {
            HStack(alignment: .top) {
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
    
    @ViewBuilder
    func WatchTrailerViewButton() -> some View {
        if let trailerURLString = model.trailerURLString {
            Button(action: {
                self.isShowingSheet = .movieTrailer(trailerURLString)
            }) {
                HStack {
                    Image(systemName: "play.circle")
                        .foregroundStyle(.red)
                        .font(.title2)
                    
                    Text("Watch trailer")
                        .font(AppTheme.Typography.helvetica16)
                        .foregroundStyle(.red)
                }
            }
        }
    }
    
    func CastView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 30) {
                ForEach(model.cast) { castMember in
                    VStack(alignment: .center) {
                        CastMemberImage(castMember.profile_path)
                        
                        Text(castMember.name)
                            .font(AppTheme.Typography.helvetica12)
                            .foregroundStyle(.gray)
                            .padding(.top, 1)
                        
                        Text("as")
                            .font(AppTheme.Typography.helvetica12)
                            .foregroundStyle(.gray)
                        
                        Text(castMember.character)
                            .font(AppTheme.Typography.helvetica12)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func CastMemberImage(_ posterPath: String?) -> some View {
        if let posterPath {
            WebImage(url: URL(string: "https://image.tmdb.org/t/p/w300/\(posterPath)")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFill()
            } placeholder: {
                ShimmerView()
            }
            .frame(width: 90, height: 90)
            .clipShape(Circle())
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 90)
                .foregroundStyle(.white)
        }
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
