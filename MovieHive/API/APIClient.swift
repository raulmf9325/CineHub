//
//  APIClient.swift
//  CineHub
//
//  Created by Raul Mena on 5/6/24.
//

import Foundation

struct APIClient {
    var getMovieList: (MovieList, Int) async throws -> [Movie]
    var searchMovie: (String, Int) async throws -> [Movie]
    var getDetails: (Int) async throws -> MovieDetails
    var getVideos: (Int) async throws -> [MovieVideo]
    var getRecommendations: (Int, Int) async throws -> [Movie]
    var getPersonDetails: (Int) async throws -> Person
}

extension APIClient {
    static let live: APIClient = APIClient(
        getMovieList: getMovieList(list:page:),
        searchMovie: searchMovie(_:page:),
        getDetails: getDetails(_:),
        getVideos: getVideos(_:),
        getRecommendations: getRecommendations(_:page:),
        getPersonDetails: getPersonDetails(_:)
    )
}

private func getMovieList(list: MovieList, page: Int) async throws -> [Movie] {
    let urlString = "https://api.themoviedb.org/3/movie/\(list.apiQueryTitle)?language=en-US&page=\(page)"
    let request = try urlRequest(for: urlString)
    let (data, _) = try await fetchData(request)
    var movieList = try decodeMovieList(data)
    
    if list == .upcoming {
        movieList = movieList.filter {
            if let releaseDate = $0.release_date, releaseDate < Date() {
                return false
            } else {
                return true
            }
        }
    }
    
    return movieList
}

private func searchMovie(_ query: String, page: Int) async throws -> [Movie] {
    let urlString = "https://api.themoviedb.org/3/search/movie?query=\(query)&language=en-US&page=\(page)"
    let request = try urlRequest(for: urlString)
    let (data, _) = try await fetchData(request)
    return try decodeMovieList(data)
}

private func getDetails(_ movieId: Int) async throws -> MovieDetails {
    let urlString = "https://api.themoviedb.org/3/movie/\(movieId)?append_to_response=credits&language=en-US"
    let request = try urlRequest(for: urlString)
    let (data, _) = try await fetchData(request)
    let decoder = JSONDecoder()
    return try decoder.decode(MovieDetails.self, from: data)
}

private func getPersonDetails(_ personId: Int) async throws -> Person {
    let urlString = "https://api.themoviedb.org/3/person/\(personId)?language=en-US"
    let request = try urlRequest(for: urlString)
    let (data, _) = try await fetchData(request)
    let decoder = JSONDecoder()
    return try decoder.decode(Person.self, from: data)
}

private func getRecommendations(_ movieId: Int, page: Int) async throws -> [Movie] {
    let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/recommendations?language=en-US&page=\(page)"
    let request = try urlRequest(for: urlString)
    let (data, _) = try await fetchData(request)
    return try decodeMovieList(data)
}

private func getVideos(_ movieId: Int) async throws -> [MovieVideo] {
    let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/videos?language=en-US"
    let request = try urlRequest(for: urlString)
    let (data, _) = try await fetchData(request)
    let decoder = JSONDecoder()
    return try decoder
        .decode(VideosResponse.self, from: data)
        .results
}

private func urlRequest(for urlString: String) throws -> URLRequest {
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(Secrets.accessToken)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "accept")
    
    return request
}

private func decodeMovieList(_ data: Data) throws -> [Movie] {
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    
    return try decoder
        .decode(NowPlayingResponse.self, from: data)
        .results
        .compactMap { $0.movie }
}

private func fetchData(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    return (data, httpResponse)
}

