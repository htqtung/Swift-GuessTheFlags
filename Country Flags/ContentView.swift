//
//  ContentView.swift
//  Country Flags
//
//  Created by Tung Huynh on 28.4.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var gameWon = false
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var guessedCountries = [String]()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    func continueGame() {
        if gameWon {
            score = 0
            countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
            gameWon = false
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
        
    }
    
    func flagTapped(_ number: Int) {
        if number != correctAnswer {
            scoreTitle =   "Wrong! That's the flag of \(countries[number])"
            showingAlert = true
        } else if countries.count > 3 {
            score += 1
            countries.remove(at: number)
            continueGame()
        } else {
            score += 1
            gameWon = true
            scoreTitle = "You won!"
            showingAlert = true
        }
    }

    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            /* Create an effect of 2 cicles, one inside another, center placed at the top of the screen */
//            RadialGradient(stops: [
//                .init(color: Color(red: 0.7, green: 0.1, blue: 0.28), location: 0.4),
//                .init(color: Color(red: 0.2, green: 0.4, blue: 0.9), location: 0.4),
//            ], center: .top, startRadius: 200, endRadius: 400)
//                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of").foregroundColor(.white).font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer]).foregroundColor(.white).font(.largeTitle.weight(.semibold))
                    }
                                        
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number]).renderingMode(.original)
                        }
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingAlert) {
            Button("Continue", action: continueGame)
        } message: {
            Text("Your score is \(score)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
