//
//  SpotifyTrackDetails.swift
//  djbuddy
//
//  Created by Angel Cueva on 10/21/24.
//

struct SpotifyTrackDetails: Codable {
    let danceability: Double
    let energy: Double
    let key: Int
    let loudness: Double
    let mode: Int
    let speechiness: Double
    let acousticness: Double
    let instrumentalness: Double
    let liveness: Double
    let valence: Double
    let tempo: Double
    let type: String
    let id: String
    let uri: String
    let trackHref: String
    let analysisUrl: String
    let durationMs: Int
    let timeSignature: Int
    let camelot: String

    enum CodingKeys: String, CodingKey {
        case danceability, energy, key, loudness, mode, speechiness, acousticness, instrumentalness, liveness, valence, tempo, type, id, uri
        case trackHref = "track_href"
        case analysisUrl = "analysis_url"
        case durationMs = "duration_ms"
        case timeSignature = "time_signature"
        case camelot
    }
}
