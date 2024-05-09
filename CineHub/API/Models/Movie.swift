//
//  Movie.swift
//  CineHub
//
//  Created by Raul Mena on 5/7/24.
//

import Foundation

struct Movie: Decodable, Identifiable {
    var id: Int
    var title: String
    var poster_path: String
    var vote_average: Double?
    var backdrop_path: String?
    var genre_ids: [Int]?
    var overview: String?
    var release_date: String?
}

struct FailableMovie: Decodable {
    let movie: Movie?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.movie = try? container.decode(Movie.self)
    }
}

struct NowPlayingResponse: Decodable {
    var results: [FailableMovie]
}
