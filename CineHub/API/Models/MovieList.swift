//
//  MovieList.swift
//  CineHub
//
//  Created by Raul Mena on 5/11/24.
//

import Foundation

enum MovieList: String, CaseIterable {
    case nowPlaying = "Now playing"
    case popular = "Popular"
    case upcoming = "Upcoming"
    case topRated = "Top Rated"
}

extension MovieList {
    var apiQueryTitle: String {
        switch self {
        case .nowPlaying:
            return "now_playing"
        case .popular:
            return "popular"
        case .upcoming:
            return "upcoming"
        case .topRated:
            return "top_rated"
        }
    }
}
