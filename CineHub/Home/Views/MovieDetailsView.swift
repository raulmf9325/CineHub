//
//  MovieDetailsView.swift
//  CineHub
//
//  Created by Raul Mena on 5/13/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailsView: View {
    let title: String
    let overview: String
    let posterPath: String
    let releaseDate: Date?
    
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
            
            VStack(alignment: .leading) {
                ReleaseDateText()
                OverviewText()
                    .padding(.top)
            }
            .padding(.leading, 30)
            .padding(.trailing)
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
    
    func TitleText() -> some View {
        Text(title)
            .font(AppTheme.Typography.helvetica18)
            .foregroundStyle(.white)
    }
    
    func OverviewText() -> some View {
        Text(overview)
            .font(AppTheme.Typography.helvetica15)
            .foregroundStyle(.white)
    }
    
    @ViewBuilder
    func ReleaseDateText() -> some View {
        if let releaseDate {
            HStack {
                Text("Release date:")
                    .font(AppTheme.Typography.helvetica16Bold)
                Text(formatDate(releaseDate))
                    .font(AppTheme.Typography.helvetica16)
            }
            .foregroundStyle(.white)
        }
    }
    
    func PosterImage() -> some View {
        GeometryReader { geometry in
            WebImage(url: URL(string: "https://image.tmdb.org/t/p/w1280/\(posterPath)")) { image in
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
        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w300/\(posterPath)")) { image in
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
    MovieDetailsView(title: "The Hobbit: The Battle of the Five Armies",
                     overview: "Immediately after the events of The Desolation of Smaug, Bilbo and the dwarves try to defend Erebor's mountain of treasure from others who claim it: the men of the ruined Laketown and the elves of Mirkwood. Meanwhile an army of Orcs led by Azog the Defiler is marching on Erebor, fueled by the rise of the dark lord Sauron. Dwarves, elves and men must unite, and the hope for Middle-Earth falls into Bilbo's hands.",
                     posterPath: "/xT98tLqatZPQApyRmlPL12LtiWp.jpg",
                     releaseDate: Date())
}
