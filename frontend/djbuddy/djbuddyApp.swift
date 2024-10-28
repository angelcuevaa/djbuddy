//
//  djbuddyApp.swift
//  djbuddy
//
//  Created by Angel Cueva on 10/10/24.
//

import SwiftUI

@main
struct djbuddyApp: App {
    init(){
        loadEnv()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    func loadEnv() {
            guard let filePath = Bundle.main.path(forResource: ".env", ofType: nil) else {
                print(".env file not found")
                return
            }
            
            do {
                let content = try String(contentsOfFile: filePath, encoding: .utf8)
                let lines = content.components(separatedBy: "\n")
                for line in lines {
                    if line.isEmpty || line.hasPrefix("#") { continue }
                    let keyValue = line.components(separatedBy: "=")
                    if keyValue.count == 2 {
                        let key = keyValue[0].trimmingCharacters(in: .whitespacesAndNewlines)
                        let value = keyValue[1].trimmingCharacters(in: .whitespacesAndNewlines)
                        setenv(key, value, 1)
                    }
                }
            } catch {
                print("Error reading .env file: \(error)")
            }
        }
}
