//
//  DataLoader.swift
//  djbuddy
//
//  Created by Angel Cueva on 10/20/24.
//

import UIKit

class DataLoader: ObservableObject{
    @Published var image: UIImage? = nil
    @Published var spotifyTrack: SpotifyTrack? = nil
    @Published var spotifyTrackDetails: SpotifyTrackDetails? = nil
    @Published var spotifyRecommendations: SpotifyRecommendations? = nil
    @Published var finalTrack: FinalTrack? = nil
    @Published var finalRecommendations: [FinalTrack] = []
    @Published var isLoading = true
    @Published var success = false
    let apiKey = ProcessInfo.processInfo.environment["API_KEY"]


    
    func loadData (isrc: String) async throws {
        //get image
        //get track -> if track exists in spotify -> get track details based on id -> get recommendations -> load each recommendations pictures -> render
        //if track doesn't exist in spotify -> get shazamio recommendations based on recognize id -> load each recommendations pictures -> render
        isLoading = true
        let spotifyTrack = try await getSpotifyTrack(isrc: isrc)
        if(spotifyTrack.id != nil && spotifyTrack.error == nil){
            //get spotify recommendations
            let spotifyTrackDetails = try await getSpotifyTrackDetails(trackId: spotifyTrack.id ?? "")
            guard let mainImage = URL(string: spotifyTrack.album?.images[0].url ?? "") else { return }
            
            Task{
                let (imageData, _) = try await URLSession.shared.data(from: mainImage)
                finalTrack = FinalTrack(name: spotifyTrack.name ?? "N/A", subtitle: spotifyTrack.artists?.compactMap { $0.name }.joined(separator: ", ") ?? "N/A", link: spotifyTrack.externalUrls?.spotify ?? "", image: UIImage(data: imageData)!, camelot: spotifyTrackDetails.camelot, tempo: Int(spotifyTrackDetails.tempo.rounded()))
            }

            let spotifyRecommendations = try await getSpotifyRecommendations(track_id: spotifyTrack.id ?? "", tempo: Int(spotifyTrackDetails.tempo), key: spotifyTrackDetails.key)
            
            //load recommendation images asyncronously
            finalRecommendations = []
            await withTaskGroup(of: Void.self){ group in
                for index in 0..<spotifyRecommendations.tracks.count{
                    group.addTask {
                        do{
                            guard let url = URL(string: spotifyRecommendations.tracks[index].album?.images[0].url ?? "") else { return }
                            let (data, _) = try await URLSession.shared.data(from: url)
                            let names = spotifyRecommendations.tracks[index].artists?.compactMap { $0.name }.joined(separator: ", ")
                            var temp = FinalTrack(name: spotifyRecommendations.tracks[index].name ?? "N/A", subtitle: names ?? "N/A", link: spotifyRecommendations.tracks[index].externalUrls?.spotify ?? "", image: UIImage())
                            temp.image = UIImage(data: data)!
                            self.finalRecommendations.append(temp)
                        }
                        catch{
                            print("Error creating final track arr")
                        }
                    }
                }
            }
            print (self.finalRecommendations)
            success = true
            isLoading = false
        }
        else{
            //get shazamio recommendations
            isLoading = false
        }
    }
    // Async function to fetch the image
        private func fetchImage(url: URL) async throws -> UIImage {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw URLError(.badServerResponse)
            }
            return image
        }
    // Async function to fetch the API data
    private func getSpotifyTrack(isrc: String) async throws -> SpotifyTrack {
            let url = URL(string: "http://djbuddy.us-west-2.elasticbeanstalk.com/spotify/track")!
            // Create a URLRequest object
            var request = URLRequest(url: url)
            
            // Set the HTTP method to POST
            request.httpMethod = "POST"
            
            // Set the Content-Type header to application/json
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
            // Create a dictionary with the key "isrc" and the passed string as the value
            let jsonBody: [String: String] = ["isrc": isrc]

            
            // Convert the Swift dictionary to JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [])

            // Set the HTTP body with the JSON data
            request.httpBody = jsonData
            request.setValue("Api-Key \(apiKey ?? "")", forHTTPHeaderField: "Authorization")
            
            // Perform the request using URLSession
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // Decode the response
            let decodedResponse = try JSONDecoder().decode(SpotifyTrack.self, from: data)
            let result = String(decoding: data, as: UTF8.self)
            print(result)

            return decodedResponse
        }
    private func getSpotifyTrackDetails(trackId: String) async throws -> SpotifyTrackDetails {
            let url = URL(string: "http://djbuddy.us-west-2.elasticbeanstalk.com/spotify/track-details?track_id=\(trackId)")!
            // Create a URLRequest object
            var request = URLRequest(url: url)
            
            // Set the HTTP method to POST
            request.httpMethod = "GET"
            
            // Set the Content-Type header to application/json
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")


            // Set the HTTP body with the JSON data
            request.setValue("Api-Key \(apiKey ?? "")", forHTTPHeaderField: "Authorization")
            
            // Perform the request using URLSession
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // Decode the response
            let decodedResponse = try JSONDecoder().decode(SpotifyTrackDetails.self, from: data)
            let result = String(decoding: data, as: UTF8.self)
            print(result)

            return decodedResponse
        }
    private func getSpotifyRecommendations(track_id: String, tempo: Int, key: Int) async throws -> SpotifyRecommendations {
        let url = URL(string: "http://djbuddy.us-west-2.elasticbeanstalk.com/spotify/recommendations?track_id=\(track_id)&tempo=\(tempo)&key=\(key)")!
            // Create a URLRequest object
            var request = URLRequest(url: url)
            
            // Set the HTTP method to POST
            request.httpMethod = "GET"
            
            // Set the Content-Type header to application/json
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // Set the HTTP body with the JSON data
            request.setValue("Api-Key \(apiKey ?? "")", forHTTPHeaderField: "Authorization")
            
            // Perform the request using URLSession
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // Decode the response
            let decodedResponse = try JSONDecoder().decode(SpotifyRecommendations.self, from: data)
            let result = String(decoding: data, as: UTF8.self)
            print(result)

            return decodedResponse
        }
}
