//
//  APIClient.swift
//  CineHub
//
//  Created by Raul Mena on 5/6/24.
//

import Foundation

struct APIClient {
    var getNowPlaying: (Int) async throws -> [Movie]
}

extension APIClient {
    static let live: APIClient = APIClient(getNowPlaying: getNowPlaying(page:))
}

private func getNowPlaying(page: Int) async throws -> [Movie] {
    let urlString = "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=\(page)"
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(Secrets.accessToken)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "accept")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    let nowPlayingResponse = try JSONDecoder().decode(NowPlayingResponse.self, from: data)
    return nowPlayingResponse.results
}
