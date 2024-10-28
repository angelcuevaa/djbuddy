//
//  ContentView.swift
//  djbuddy
//
//  Created by Angel Cueva on 10/10/24.
//

import SwiftUI
import AVFAudio


struct ContentView: View {
    @State var track: RecognizeDetails?
    @State private var state: String = "Tap To Listen"
    @State private var showSuccess: Bool = false
    @State private var showFailure: Bool = false
    @State private var isButtonDisabled: Bool = false
    @State private var dataLoader: DataLoader? = nil
    @State private var isListening: Bool = false
    let apiKey = ProcessInfo.processInfo.environment["API_KEY"]


    @ObservedObject var audio = AudioRecorder()
    
    
    
    
    var body: some View{
        NavigationStack {
            
            VStack{
            
                ZStack {
                    RecordingAnimationView(isListening: $isListening) // Pass binding to animation view

                    // Transparent button overlay
                    Button(action: {
                        if !audio.recording{
                            isListening.toggle()
                            initiate()
                              
                        }
                    }) {
                        Color.black.opacity(0.0001) // Make the button background clear
                    }
                    .frame(width: 150, height: 150) // Set the frame to match the animation size
                    .buttonStyle(PlainButtonStyle()) // Use plain button style
                    .disabled(isButtonDisabled)

                }
                .padding(40)
                
                 
                Text(state)
                    .font(.title3)
                    .bold()
                
                    .navigationDestination(isPresented: $showFailure) {
                        SecondView(track: track)
                    }
                    .navigationDestination(isPresented: $showSuccess) {
                        ThirdView(dataLoader: dataLoader)
                    }
            }
        }

         
    }
    func initiate(){
        isButtonDisabled = true
        // Stage 1: Update text before starting the task
        state = "Listening..."
        audio.startRecording()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            audio.stopRecording()
            state = "Analyzing..."
            if let audioBytes = audio.getRecordedAudioBytes() {
                print("Audio file size, in bytes: \(audioBytes.count)")
                Task {
                    await recognize(audioData: audioBytes)
                    //we set variable "track" to the results of recogize in the function. We can now access recognize's response
                    if ( track?.track == nil) {
                        showFailure = true
                    }
                    else{
                        state = "Loading..."

                        do{
                            dataLoader = nil
                            dataLoader = DataLoader()
                            try await dataLoader!.loadData(isrc: track?.track?.isrc ?? "")
                            
                        }
                        catch{
                            print("error")
                            return
                        }
                        if (!dataLoader!.isLoading && dataLoader!.success){
                            showSuccess = true

                        }
                        else{
                            showFailure = true
                        }
                         
                    }
                    //reset home page. Not sure if this will execute after rendering other views
                    state = "Click to Listen"
                    isListening.toggle()
                    isButtonDisabled = false
                    
                }
            }
            
            else{
                print("nada")
            }
        }
    }
    func createMultipartBody(boundary: String, filePathKey: String, audioData: Data, fileName: String, mimeType: String) -> Data {
        var body = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        // Add audio file data to the body
        body.append(Data(boundaryPrefix.utf8))
        body.append(Data("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(fileName)\"\r\n".utf8))
        body.append(Data("Content-Type: \(mimeType)\r\n\r\n".utf8))
        body.append(audioData)
        body.append(Data("\r\n".utf8))
        
        // End boundary
        body.append(Data("--\(boundary)--\r\n".utf8))
        
        return body
    }
    func recognize(audioData: Data) async {
        // Define the server URL
        guard let serverURL = URL(string: "http://djbuddy.us-west-2.elasticbeanstalk.com/recognize") else {
            print("Invalid server URL")
            return
        }
        
        // Create a URLRequest object
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        
        // Set the boundary and Content-Type for the multipart request
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Api-Key \(apiKey ?? "")", forHTTPHeaderField: "Authorization")
        
        
        // Create the multipart body
        let mimeType = "audio/mpeg"  // Adjust based on the audio format, e.g., "audio/wav"
        let body = createMultipartBody(boundary: boundary, filePathKey: "audio", audioData: audioData, fileName: "recording.wav", mimeType: mimeType)
        
        // Set the body and content length
        request.httpBody = body
        request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        
        // Send the request using URLSession
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: body)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                let result = String(decoding: data, as: UTF8.self)
//                print("Upload successful: \(result)")
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do{
                    let details = try decoder.decode(RecognizeDetails.self, from: data)
                    print(details)
                    track = details
                }catch{
                    print(error)
                }
            } else {
                print("Failed to upload: \(response)")
            }
            
        } catch {
            print("Error uploading audio data: \(error)")
        }
    }
}
struct SecondView: View{
    var track: RecognizeDetails?
    var body: some View{
        ZStack{
            Color.black // Set the background color for the entire view
                           .ignoresSafeArea() // Ensures the color covers the entire screen, including safe areas
            VStack{
                Image(systemName: "exclamationmark.circle.fill")
                                .resizable() // Make it resizable if needed
                                .frame(width: 50, height: 50) // Set frame size
                                .foregroundColor(.white) // Change color to gray
                Text("No matches found")
                    .font(.title)
                    .onAppear {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.error)
                    }
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Action to go back, e.g., dismiss or pop the view
                    // You can use a presentation mode if needed
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                               .font(.system(size: 16, weight: .bold)) // Font size for the xmark
                               .foregroundColor(.white) // Color of the xmark
                               .frame(width: 30, height: 30) // Set the size of the circle
                               .background(Color.gray) // Change to your desired color
                               .clipShape(Circle()) // Clip to a circle shape
                               .overlay(Circle().stroke(Color.black.opacity(0.2), lineWidth: 1)) // Optional: border for the circle
                               .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Add shadow
                               .padding() // Optional: add padding around the circle
                               .overlay(
                                   Image(systemName: "xmark")
                                       .font(.system(size: 10, weight: .bold)) // Smaller xmark
                                       .foregroundColor(.white) // Color of the xmark
                               )
                }
            }
        }
        .navigationBarBackButtonHidden(true)

    }
    @Environment(\.dismiss) private var dismiss
}
struct ThirdView: View{
    var dataLoader: DataLoader?
    //move all loading to home view and pass all components to this view
    //images, recommendations, etc
    // Camelot Wheel colors based on the image
    let camelotColors: [String: UIColor] = [
        "1A": UIColor(red: 0.40, green: 1.00, blue: 0.80, alpha: 1.0),  // Bright teal
        "1B": UIColor(red: 0.20, green: 1.00, blue: 0.60, alpha: 1.0),  // Cyan
        "2A": UIColor(red: 0.20, green: 1.00, blue: 0.40, alpha: 1.0),  // Light green
        "2B": UIColor(red: 0.20, green: 0.90, blue: 0.20, alpha: 1.0),  // Green
        "3A": UIColor(red: 0.60, green: 0.90, blue: 0.20, alpha: 1.0),  // Yellow-green
        "3B": UIColor(red: 0.80, green: 1.00, blue: 0.20, alpha: 1.0),  // Light lime
        "4A": UIColor(red: 1.00, green: 0.80, blue: 0.20, alpha: 1.0),  // Yellow
        "4B": UIColor(red: 1.00, green: 0.60, blue: 0.20, alpha: 1.0),  // Orange-yellow
        "5A": UIColor(red: 1.00, green: 0.40, blue: 0.20, alpha: 1.0),  // Orange
        "5B": UIColor(red: 1.00, green: 0.20, blue: 0.20, alpha: 1.0),  // Reddish-orange
        "6A": UIColor(red: 1.00, green: 0.20, blue: 0.40, alpha: 1.0),  // Red-pink
        "6B": UIColor(red: 1.00, green: 0.20, blue: 0.60, alpha: 1.0),  // Hot pink
        "7A": UIColor(red: 1.00, green: 0.20, blue: 0.80, alpha: 1.0),  // Bright pink
        "7B": UIColor(red: 1.00, green: 0.40, blue: 1.00, alpha: 1.0),  // Light magenta
        "8A": UIColor(red: 1.00, green: 0.60, blue: 1.00, alpha: 1.0),  // Lavender pink
        "8B": UIColor(red: 1.00, green: 0.80, blue: 1.00, alpha: 1.0),  // Light pink
        "9A": UIColor(red: 0.80, green: 0.60, blue: 1.00, alpha: 1.0),  // Lavender
        "9B": UIColor(red: 0.60, green: 0.40, blue: 1.00, alpha: 1.0),  // Light purple
        "10A": UIColor(red: 0.40, green: 0.20, blue: 1.00, alpha: 1.0), // Purple
        "10B": UIColor(red: 0.20, green: 0.20, blue: 1.00, alpha: 1.0), // Deep blue
        "11A": UIColor(red: 0.20, green: 0.40, blue: 1.00, alpha: 1.0), // Blue
        "11B": UIColor(red: 0.20, green: 0.60, blue: 1.00, alpha: 1.0), // Sky blue
        "12A": UIColor(red: 0.20, green: 0.80, blue: 1.00, alpha: 1.0), // Cyan-blue
        "12B": UIColor(red: 0.20, green: 1.00, blue: 1.00, alpha: 1.0),  // Light teal
        "N/A": UIColor.black
    ]
    var body: some View{
        ZStack{
            ScrollView{
                
                VStack(alignment: .leading, spacing: 4){
                    
                    ZStack{
                        Image(uiImage: dataLoader!.finalTrack?.image ?? UIImage())
                            .resizable()  // Make the image resizable
                            .scaledToFill()
                            .ignoresSafeArea()
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.clear, location: 0.5), // 50% point
                                .init(color: Color.black.opacity(0.7), location: 0.75),
                                .init(color: Color.black.opacity(0.9), location: 0.9),
                            ]),
                            startPoint: .top,    // Start the gradient from the top
                            endPoint: .bottom    // End at the bottom (vertical only)
                        )
                        .ignoresSafeArea()
                        //                        .frame(height: UIScreen.main.bounds.height  * 0.7)  // Make sure it covers the screen height
                        //                        .offset(y: UIScreen.main.bounds.height * 0.3)  // Start the gradient at 70% (1 - 0.7 = 0.3)
                        //                        .ignoresSafeArea()
                        VStack{
                            Spacer()
                            
                            
                            Text(dataLoader?.finalTrack?.name ?? "N/A")
                                .font(.largeTitle)
                            Text(dataLoader?.finalTrack?.subtitle ?? "N/A")
                            HStack{
                                Spacer()
                                VStack{
                                    Text(dataLoader?.finalTrack?.camelot ?? "N/A")
                                        .foregroundStyle(Color(camelotColors[dataLoader!.finalTrack?.camelot ?? "N/A"] ?? UIColor.black))
                                        .font(.headline)
                                    Text("Camelot")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                VStack{
                                    Text(String(dataLoader?.finalTrack?.tempo ?? 0))
                                        .font(.headline)
                                    Text("BPM")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                }
                                .padding(.leading, 10)
                                Spacer() // Fills remaining space
                                
                                
                                
                            }.padding(.bottom, 10)
                            
                        }
                    }
                    
                    .ignoresSafeArea()
                
                   
                    Text("Recommendations")
                        .font(.title2)
                        .padding(.leading, 10)
                    
                        
                    ForEach(0..<(dataLoader!.finalRecommendations.count), id: \.self) { index in
                        HStack {
                            // Display the UIImage as SwiftUI Image
                            Image(uiImage: dataLoader!.finalRecommendations[index].image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                            
                            // Display the name
                            VStack(alignment: .leading, spacing: 4){
                                Text(dataLoader!.finalRecommendations[index].name)
                                    .font(.headline)
                                Text(dataLoader!.finalRecommendations[index].subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading, 10)
                            
                            Spacer()
                            Button(action: {
                                if let songURL = URL(string: dataLoader!.finalRecommendations[index].link) {
                                    UIApplication.shared.open(songURL)
                                }
                            }) {
                                Image(systemName: "arrow.up.right.square")
                                    .font(.system(size: 24))  // Set the size of the icon
                                    .foregroundColor(.blue)   // Optional: Change the icon color
                                    .padding(.trailing, 10)   // Add some space to the right
                            }
                        }
                        .padding()
                    }
                }
                
                
                .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Action to go back, e.g., dismiss or pop the view
                        // You can use a presentation mode if needed
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                                   .font(.system(size: 16, weight: .bold)) // Font size for the xmark
                                   .foregroundColor(.white) // Color of the xmark
                                   .frame(width: 30, height: 30) // Set the size of the circle
                                   .background(Color.gray) // Change to your desired color
                                   .clipShape(Circle()) // Clip to a circle shape
                                   .overlay(Circle().stroke(Color.black.opacity(0.2), lineWidth: 1)) // Optional: border for the circle
                                   .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Add shadow
                                   .padding() // Optional: add padding around the circle
                                   .overlay(
                                       Image(systemName: "xmark")
                                           .font(.system(size: 10, weight: .bold)) // Smaller xmark
                                           .foregroundColor(.white) // Color of the xmark
                                   )
                    }
                }
            }
            .ignoresSafeArea()
            
        }
        .navigationBarBackButtonHidden(true)
        
            
        
    }
    @Environment(\.dismiss) private var dismiss

}
struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView(audio: AudioRecorder())
    }
}


//#Preview {
//    ContentView()
//}
