//
//  Flashcard.swift
//  Flash Card App
//
//  Created by Jared Nash on 6/27/24.
//

import Foundation

// Model for a flashcard
struct Flashcard: Identifiable {
    let id = UUID()
    var term: String
    var definition: String
}

// Model for a flashcard set
struct FlashcardSet: Identifiable {
    let id = UUID()
    var name: String
    var cards: [Flashcard]
}

