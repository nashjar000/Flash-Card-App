//
//  ContentView.swift
//  Flash Card App
//
//  Created by Jared Nash on 6/27/24.
//

import SwiftUI

// Main view showing a list of flashcard sets
struct ContentView: View {
    
    @State private var flashcardSets: [FlashcardSet] = []
    
    // State to control the presentation of AddFlashcardSetView
    @State private var showingAddFlashcardSetView = false
    
    var body: some View {
        NavigationView {
            List {
                // Iterate over flashcard sets
                ForEach($flashcardSets) { $set in
                    NavigationLink(destination: FlashcardView(flashcardSet: $set)) {
                        Text(set.name)
                    }
                }
            }
            .navigationTitle("Flashcard Sets")
            .navigationBarItems(
                leading: ShareLink(item: URL(string: "https://developer.apple.com/xcode/swiftui")!),
                trailing: Button(action: {
                    // Show the view to add a new flashcard set
                    showingAddFlashcardSetView = true
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            )
            .sheet(isPresented: $showingAddFlashcardSetView) {
                // Present the view to add a new flashcard set
                AddFlashcardSetView(flashcardSets: $flashcardSets)
            }
        }
    }
}

// View for adding a new flashcard
struct AddFlashcardView: View {
    
    // Binding to the list of flashcards
    @Binding var flashcards: [Flashcard]
    @Environment(\.presentationMode) var presentationMode
    
    // State to keep track of the term and definition input by the user
    @State private var term = ""
    @State private var definition = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Flashcard")) {
                    TextField("Term", text: $term)
                    TextField("Definition", text: $definition)
                }
                
                // Button to add a new flashcard
                Button(action: {
                    let newFlashcard = Flashcard(term: term, definition: definition)
                    flashcards.append(newFlashcard)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Flashcard")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(term.isEmpty || definition.isEmpty)
            }
            .navigationTitle("Add Flashcard")
        }
    }
}

// View for displaying and navigating through flashcards in a set
struct FlashcardView: View {
    
    @Binding var flashcardSet: FlashcardSet
    @State private var currentCardIndex = 0
    @State private var isFlipped = false
    @State private var showingAddFlashcardView = false
    
    var body: some View {
        VStack {
            Text(flashcardSet.name)
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            // Check if there are any flashcards before displaying the card
            if !flashcardSet.cards.isEmpty {
                // View for flipping the card
                VStack {
                    ZStack {
                        // Front side of the card
                        if !isFlipped {
                            Text(flashcardSet.cards[currentCardIndex].term)
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .padding()
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .padding()
                                .rotation3DEffect(
                                    Angle(degrees: 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                        } else {
                            // Back side of the card
                            Text(flashcardSet.cards[currentCardIndex].definition)
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .padding()
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .padding()
                                .rotation3DEffect(
                                    Angle(degrees: 180),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                        }
                    }
                    .rotation3DEffect(
                        Angle(degrees: isFlipped ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .animation(.easeInOut(duration: 0.5), value: isFlipped)
                    .onTapGesture {
                        isFlipped.toggle()
                    }
                    
                    Spacer()
                    
                    HStack {
                        // Button to show the previous card
                        Button(action: {
                            if currentCardIndex > 0 {
                                currentCardIndex -= 1
                                isFlipped = false
                            }
                        }) {
                            Text("Previous")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                        .disabled(flashcardSet.cards.isEmpty || currentCardIndex == 0)
                        
                        Spacer()
                        
                        // Button to show the next card
                        Button(action: {
                            if currentCardIndex < flashcardSet.cards.count - 1 {
                                currentCardIndex += 1
                                isFlipped = false
                            }
                        }) {
                            Text("Next")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                        .disabled(flashcardSet.cards.isEmpty || currentCardIndex == flashcardSet.cards.count - 1)
                    }
                    .padding()
                    
                    // Button to add a new flashcard
                    Button(action: {
                        showingAddFlashcardView = true
                    }) {
                        Text("Add Flashcard")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    .sheet(isPresented: $showingAddFlashcardView) {
                        // Present the view to add a new flashcard
                        AddFlashcardView(flashcards: $flashcardSet.cards)
                    }
                }
            } else {
                VStack {
                    Text("No flashcards available")
                        .font(.title)
                        .foregroundColor(.gray)
                    
                    // Button to add a new flashcard when no flashcards are available
                    Button(action: {
                        showingAddFlashcardView = true
                    }) {
                        Text("Add Flashcard")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    .sheet(isPresented: $showingAddFlashcardView) {
                        // Present the view to add a new flashcard
                        AddFlashcardView(flashcards: $flashcardSet.cards)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

// View for adding a new flashcard set
struct AddFlashcardSetView: View {
    
    @Binding var flashcardSets: [FlashcardSet]
    @Environment(\.presentationMode) var presentationMode
    
    // State to keep track of the set name input by the user
    @State private var setName = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Flashcard Set")) {
                    TextField("Set Name", text: $setName)
                }
                
                // Button to add a new flashcard set
                Button(action: {
                    let newFlashcardSet = FlashcardSet(name: setName, cards: [])
                    flashcardSets.append(newFlashcardSet)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Flashcard Set")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(setName.isEmpty)
            }
            .navigationTitle("Add Flashcard Set")
        }
    }
}

// Function  delete flash card set:


// Preview provider for ContentView
#Preview {
    ContentView()
}
