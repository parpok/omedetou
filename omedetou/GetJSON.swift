//
//  GetJSON.swift
//  omedetou
//
//  Created by Patryk Puciłowski on 01/03/2024.
//
// its not get json you baka. For now. at least. youre iterating over a fucking array
import Foundation

struct affirmationClass: Decodable, Identifiable {
    var id: UUID
    var content: String
}

let affirmations: [affirmationClass] = [affirmationClass(id: UUID(), content: "おめでとう"), affirmationClass(id: UUID(), content: "おめでたいな"), affirmationClass(id: UUID(), content: "Congratulations"), affirmationClass(id: UUID(), content: "Congrats"), affirmationClass(id: UUID(), content: "Thank you mother"), affirmationClass(id: UUID(), content: "Thank you father"), affirmationClass(id: UUID(), content: "Gratulacje"), affirmationClass(id: UUID(), content: "Gratuluje")]

let randomAffirmation = affirmations.randomElement()?.content
