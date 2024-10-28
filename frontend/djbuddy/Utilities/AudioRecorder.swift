//
//  AudioRecorder.swift
//  djbuddy
//
//  Created by Angel Cueva on 10/12/24.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

var audioPlayer: AVAudioPlayer?


class AudioRecorder: ObservableObject{
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    var recording = false{
        didSet{
            objectWillChange.send(self)
        }
    }
    func startRecording(){
        let recordingSession = AVAudioSession.sharedInstance()
        do{
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try recordingSession.setActive(true)
            
        }catch{
            print("Failed to set recording session")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let audioFileName = docPath.appendingPathComponent("recording.wav")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),  // Uncompressed WAV format
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false
        ] as [String : Any]
        do{
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.record()
            
            recording = true
        }catch{
            print("couldn't start recording")
        }
    }
    func stopRecording(){
        audioRecorder.stop()
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print (paths[0])
        recording = false
    } 
    func getRecordedAudioBytes() -> Data? {
        if let recordedFileURL = audioRecorder?.url {
            do {
                let audioData = try Data(contentsOf: recordedFileURL)
                return audioData
            } catch {
                print("Failed to read audio file: \(error)")
            }
        }
        return nil
    }
    func playRecording() {
        if let recordedFileURL = audioRecorder?.url {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: recordedFileURL)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Failed to play audio: \(error)")
            }
        }
    }
    
    
}
