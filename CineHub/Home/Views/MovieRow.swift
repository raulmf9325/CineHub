//
//  MovieRow.swift
//  CineHub
//
//  Created by Raul Mena on 5/7/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieRow: View {
    let title: String
    let posterPath: String
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    
    var body: some View {
        VStack {
            posterImage
            Text(title)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.white)
                .font(AppTheme.Typography.helvetica12)
        }
    }
    
    var posterImage: some View {
        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w300/\(posterPath)")) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFill()
                .frame(width: imageWidth, height: imageHeight)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } placeholder: {
            ShimmerView()
                .frame(width: imageWidth, height: imageHeight)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    MovieRow(title: "An unexpected journey",
             posterPath: "",
             imageWidth: 90,
             imageHeight: 110)
}
