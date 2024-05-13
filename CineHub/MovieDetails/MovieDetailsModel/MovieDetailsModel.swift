//
//  MovieDetailsModel.swift
//  CineHub
//
//  Created by Raul Mena on 5/13/24.
//

import SwiftUI

@MainActor
class MovieDetailsModel: ObservableObject {
    @Published var onError = false
    @Published var genres: [String] = []
    @Published var director: String?
    
    let movieId: Int
    let title: String
    let overview: String
    let posterPath: String
    let releaseDate: Date?
    let backdropPath: String?
    
    private let apiClient: APIClient
    
    init(movieId: Int,
         title: String,
         overview: String,
         posterPath: String,
         backdropPath: String?,
         releaseDate: Date?,
         apiClient: APIClient) {
        self.movieId = movieId
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.apiClient = apiClient
        
        getMovieDetails()
    }
    
    private func getMovieDetails() {
        Task { @MainActor in
            do {
                onError = false
                let details = try await apiClient.getDetails(movieId)
                self.genres = details.genres.map { $0.name }
                
                self.director = details.credits.crew.first { $0.job == "Director" }?.name
            } catch {
                print("Error getting details for movie '\(title)': \(error)")
                onError = true
            }
        }
    }
}

extension MovieDetailsModel {
    static let preview = MovieDetailsModel(movieId: 122917,
                                           title: "The Hobbit: The Battle of the Five Armies",
                                           overview: "Immediately after the events of The Desolation of Smaug, Bilbo and the dwarves try to defend Erebor's mountain of treasure from others who claim it: the men of the ruined Laketown and the elves of Mirkwood. Meanwhile an army of Orcs led by Azog the Defiler is marching on Erebor, fueled by the rise of the dark lord Sauron. Dwarves, elves and men must unite, and the hope for Middle-Earth falls into Bilbo's hands.",
                                           posterPath: "/xT98tLqatZPQApyRmlPL12LtiWp.jpg",
                                           backdropPath: "/bVmSXNgH1gpHYTDyF9Q826YwJT5.jpg",
                                           releaseDate: Date(),
                                           apiClient: .live)
}
