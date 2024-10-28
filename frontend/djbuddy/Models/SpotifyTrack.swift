import Foundation
import UIKit

// MARK: - TrackDetails
struct SpotifyTrack: Codable {
    let album: Album?
    let artists: [Artist]?
//    let availableMarkets: [String]?
    let discNumber: Int?
    let durationMs: Int?
    let explicit: Bool?
    let externalIds: ExternalIDs?
    let externalUrls: ExternalUrls?
    let href: String?
    let id: String?
    let isLocal: Bool?
    let name: String?
    let popularity: Int?
    let previewUrl: String?
    let trackNumber: Int?
    let type: String?
    let uri: String?
    let error: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case album, artists
//        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case explicit
        case externalIds = "external_ids"
        case externalUrls = "external_urls"
        case href, id
        case isLocal = "is_local"
        case name, popularity
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case type, uri
        case error, message
    }
}

// MARK: - Album
struct Album: Codable {
    let albumType: String
    let artists: [Artist]
//    let availableMarkets: [String]
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [SpotifyImage]
    let name: String
    let releaseDate: String
    let releaseDatePrecision: String
    let totalTracks: Int
    let type: String
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
//        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type, uri
    }
}

// MARK: - Artist
struct Artist: Codable {
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let name: String
    let type: String
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String
}

// MARK: - ExternalIDs
struct ExternalIDs: Codable {
    let isrc: String
}

// MARK: - Image
struct SpotifyImage: Codable {
    let height: Int
    let url: String
    let width: Int
}
