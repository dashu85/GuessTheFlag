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
    
    @State private var positionflagTapped = 0
    
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
                VStack (spacing: 20) {
                                VStack {
                                    Text("Please tap the flag of")
                                        .font(.subheadline.weight(.heavy))
                                        .foregroundStyle(.black)
                                    Text(countries[correctAnswer])  // choose this flag!
                                        .font(.largeTitle.weight(.semibold))
                                        .foregroundStyle(.black)
                                }
                                ForEach(0..<3) { number in
                                    Button {
                                        positionflagTapped = number
                                        flagTapped(number)
                                    } label: {
                                        Image(countries[number])
                                            .clipShape(.rect(cornerRadius: 10))
                                            .shadow(radius: 5)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Text("Score: \(score)")
                    .foregroundStyle(Color(red: 0.992, green: 0.882, blue: 0))
                    .font(.title.bold())
                    .padding()
                Spacer()
            }
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
    }
    
    // setting scoreTitle for the alert message
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = """
                        Sorry, that was
                        the flag of \(countries[positionflagTapped])!
                        """
            if score > 0 {
                score = score
            } else {
                score = 0
            }
        }
        
        showingScore = true
    }
    
    // preparing the new round
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
