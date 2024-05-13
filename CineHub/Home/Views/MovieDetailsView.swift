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
    let posterPath: String
    
    var body: some View {
        ScrollView {
            PosterImage()
        }
        .ignoresSafeArea()
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
}

#Preview {
    MovieDetailsView(title: "An unexpected journey", 
                     posterPath: "/xT98tLqatZPQApyRmlPL12LtiWp.jpg")
}
