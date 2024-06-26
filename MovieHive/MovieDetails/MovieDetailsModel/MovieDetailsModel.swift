//
//  MovieDetailsModel.swift
//  CineHub
//
//  Created by Raul Mena on 5/13/24.
//

import SwiftUI
import IdentifiedCollections

@MainActor
class MovieDetailsModel: ObservableObject {
    @Published var isLoading = false
    @Published var onError = false
    @Published var genres: [String] = []
    @Published var director: CrewMember?
    @Published var runtime: String?
    @Published var rottenTomatoesScore: String?
    @Published var cast: [CastMember] = []
    @Published var trailerURLString: String?
    @Published var recommendations: IdentifiedArrayOf<Movie> = []
    @Published var noDetailsForSelectedPerson = false
    
    
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
        getRottenTomatoesScore()
        getMovieVideos()
        getRecommendations()
    }
    
    private func getMovieDetails() {
        Task(priority: .userInitiated) { @MainActor in
            do {
                onError = false
                let details = try await apiClient.getDetails(movieId)
                self.genres = details.genres.map { $0.name }
                self.director = details.credits.crew.first { $0.job == "Director" }
                self.cast = details.credits.cast
                
                self.runtime = details.runtime.flatMap {
                    let hours = $0 / 60
                    let mins = $0 % 60
                    return "\(hours)h \(mins)mins"
                }
            } catch {
                print("Error getting details for movie '\(title)': \(error)")
                onError = true
            }
        }
    }
    
    private func getRecommendations() {
        Task(priority: .userInitiated) { @MainActor in
            do {
                onError = false
                let recommendations = try await apiClient.getRecommendations(movieId, 1)
                self.recommendations = IdentifiedArray(uniqueElements: recommendations)
            } catch {
                print("Error getting details for movie '\(title)': \(error)")
                onError = true
            }
        }
    }
    
    private func getMovieVideos() {
        Task(priority: .userInitiated) { @MainActor in
            do {
                onError = false
                let videos = try await apiClient.getVideos(movieId)
                
                let video = videos.first { $0.name == "Official Trailer" }
                    ?? videos.first { $0.name?.contains("Trailer") == true }
                    ?? videos.first
                
                self.trailerURLString = video
                    .flatMap { video in video.key }
                    .flatMap { key in "https://www.youtube.com/embed/\(key)" }
            } catch {
                print("Error getting videos for movie '\(title)': \(error)")
                onError = true
            }
        }
    }
    
    private func getRottenTomatoesScore() {
        Task(priority: .userInitiated) { @MainActor in
            guard let rottenTitle = removeNonAlphabeticCharacters(from: title) else { return }
        
            if let percentage = try await getRottenTomatoesPercentage("https://www.rottentomatoes.com/m/\(rottenTitle)")  {
                rottenTomatoesScore = percentage
            } else if let releaseDate {
                // retry appending release date year
                let year = Calendar.current.component(.year, from: releaseDate)
                let modifiedTitle = rottenTitle + "_\(year)"
                
                if let percentage = try await getRottenTomatoesPercentage("https://www.rottentomatoes.com/m/\(modifiedTitle)")  {
                    rottenTomatoesScore = percentage
                }
            }
        }
    }
    
    private func getRottenTomatoesPercentage(_ urlString: String) async throws -> String? {
        guard let url = URL(string: urlString) else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let html = String(data: data, encoding: .utf8) else { return nil }
        return extractPercentage(from: html)
    }
    
    private func getPersonDetails(_ directorId: Int) async -> Person? {
        let person = try? await apiClient.getPersonDetails(directorId)
        if person?.biography.isEmpty == true { return nil }
        return person
    }
    
    private func onPersonButtonTapped(_ personId: Int) {
        Task(priority: .userInitiated) { @MainActor in
            isLoading = true
            let details = await getPersonDetails(personId)
            isLoading = false
            
            if details != nil {
                FlutterDependencies.shared.presentFlutterModule(route: .people(personId))
            } else {
                noDetailsForSelectedPerson = true
            }
        }
    }
    
    func onDirectorButtonTapped() {
        guard let id = director?.id else { return }
        onPersonButtonTapped(id)
    }
    
    func onCastMemberTapped(_ member: CastMember) {
        onPersonButtonTapped(member.id)
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
