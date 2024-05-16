//
//  Movie.swift
//  CineHub
//
//  Created by Raul Mena on 5/7/24.
//

import Foundation

struct Movie: Decodable, Identifiable, Hashable {
    var id: Int
    var title: String
    var overview: String
    var poster_path: String
    var backdrop_path: String?
    var release_date: Date?
}

struct FailableMovie: Decodable {
    let movie: Movie?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        do {
            self.movie = try container.decode(Movie.self)
        } catch {
            print("Error docoding movie: \(error)")
            self.movie = nil
        }
    }
}

struct NowPlayingResponse: Decodable {
    var results: [FailableMovie]
}
