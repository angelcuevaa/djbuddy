//
//  SpotifyRecommendations.swift
//  djbuddy
//
//  Created by Angel Cueva on 10/21/24.
//

struct SpotifyRecommendations: Codable {
    let tracks: [SpotifyTrack]
    let seeds: [Seed]
}
struct Seed: Codable {
    let initialPoolSize: Int
    let afterFilteringSize: Int
    let afterRelinkingSize: Int
    let id: String
    let type: String
    let href: String

    enum CodingKeys: String, CodingKey {
        case initialPoolSize = "initialPoolSize"
        case afterFilteringSize = "afterFilteringSize"
        case afterRelinkingSize = "afterRelinkingSize"
        case id, type, href
    }
}
