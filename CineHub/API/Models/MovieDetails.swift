//
//  MovieDetails.swift
//  CineHub
//
//  Created by Raul Mena on 5/13/24.
//

import Foundation

struct MovieDetails: Decodable {
    let budget: Int?
    let genres: [Genre]
    let credits: Credits
}
