//
//  Movie.swift
//  CineHub
//
//  Created by Raul Mena on 5/7/24.
//

import Foundation

struct Movie: Decodable, Identifiable {
    var id: Int?
    var title: String?
    var vote_average: Double?
    var poster_path: String?
    var backdrop_path: String?
    var genre_ids: [Int]?
    var overview: String?
    var release_date: String?
}

struct NowPlayingResponse: Decodable {
    var results: [Movie]
}
