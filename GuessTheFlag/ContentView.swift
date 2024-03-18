//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Marcus Benoit on 11.03.24.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var score = 0
    
    @State private var positionFlagTapped = 0
    @State private var gamesPlayed = 1
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.992, green: 0.882, blue: 0), location: 0.3),
                .init(color: Color(red: 0, green: 0, blue: 0), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.black)
                VStack (spacing: 20) {
                                VStack {
                                    Text("Question \(gamesPlayed) of 8")
                                        .padding()
                                        .foregroundColor(.black)
                                    Text("Please tap on the flag of")
                                        .font(.subheadline.weight(.heavy))
                                        .foregroundStyle(.black)
                                    Text(countries[correctAnswer])  // Tap on this flag!
                                        .font(.largeTitle.weight(.semibold))
                                        .foregroundStyle(.black)
                                }
                                ForEach(0..<3) { number in
                                    Button {
                                        positionFlagTapped = number
                                        flagTapped(number)
                                    } label: {
//                                        Image(countries[number])
//                                            .clipShape(.rect(cornerRadius: 10))
//                                            .shadow(radius: 5)
                                        FlagImage(number: countries[number]) // Challenge 2 Project 3 - modified Image view with customised modifiers, see struct FlagImage()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Text("Score: \(score)") // Challenge 3 - Project 3: Customized ViewModifier with View extension
                    .scoreModifier()
                Spacer()
            }
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("\(alertMessage)")
        }
    }
    
    // setting scoreTitle for the alert message
    func flagTapped(_ number: Int) {
        // checking i
        if gamesPlayed < 9 {
            if number == correctAnswer {
                scoreTitle = "Correct!"
                alertMessage = ""
                score += 1
                if gamesPlayed == 8 { resetGame() }
            } else {
                scoreTitle = "WRONG!"
                if gamesPlayed == 8 {
                    resetGame()
                } else {
                    alertMessage = "That was \(countries[positionFlagTapped])'s flag"
                }
            }
        } else {
            scoreTitle = "Your final result is \(score)!"
            resetGame()
        }
        
        showingScore = true
    }
    
    // preparing the new round
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        if gamesPlayed == 8 {
            gamesPlayed = 1
            score = 0
        } else {
            gamesPlayed += 1
        }
    }
    
    func resetGame() {
        alertMessage =  """
                        Final score: \(score)
                        Let's do it again!
                        """
    }
}

// Challenge 2 - Project 3: new FlagImage view to replace the existing Image view and replace it with custom modifiers
struct FlagImage: View {
    let number: String
    
    var body: some View {
        Image(number)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 5)
    }
}

// Challenge 3 - Project 3: new ViewModifier with an extension for View
struct ScoreModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content
                .foregroundStyle(Color(red: 0.992, green: 0.882, blue: 0))
                .font(.title.bold())
                .padding()
        }
    }
}

extension View {
    func scoreModifier() -> some View {
        modifier(ScoreModifier())
    }
}

#Preview {
    ContentView()
}
