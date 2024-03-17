//
//  GetJSON.swift
//  omedetou
//
//  Created by Patryk Puciłowski on 01/03/2024.
//
import Foundation
import OSLog

struct affirmation: Decodable, Identifiable {
    var id: UUID
    var content: String
}

func getAffirmationsFromServer() async throws -> [affirmation] {
    let backendURL = "https://omedetoubackend.fly.dev/"

    guard let url = URL(string: backendURL) else {
        throw shitBreaking.urlFuckedUp
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw shitBreaking.requestFucked
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode([affirmation].self, from: data)
    } catch {
        throw shitBreaking.dataFucked
    }
}

enum shitBreaking: Error {
    case urlFuckedUp
    case requestFucked
    case dataFucked
    case idk
}
