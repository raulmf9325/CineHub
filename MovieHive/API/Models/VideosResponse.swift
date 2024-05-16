//
//  VideosResponse.swift
//  CineHub
//
//  Created by Raul Mena on 5/15/24.
//

import Foundation

struct VideosResponse: Decodable {
    let results: [MovieVideo]
}

struct MovieVideo: Decodable {
    let key: String?
    let name: String?
}
