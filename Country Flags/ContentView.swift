//
//  ContentView.swift
//  Country Flags
//
//  Created by Tung Huynh on 28.4.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertDescription = ""
    @State private var score = 0
    @State private var gameFinished = false
    // Player has 8 tries
    let playerMaxTries = 8
    @State private var trialCounter = 1
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var guessedCountries = [String]()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    func resetGame() {
        gameFinished = false
        score = 0
        trialCounter = 1
        countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
        alertTitle = ""
        alertDescription = ""
    }
    
    func continueGame() {
        // trialCounter == playerMaxTries -> stop game
        if trialCounter < playerMaxTries {
            trialCounter += 1
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        } else {
            alertTitle = "Finished!"
            alertDescription = "You scored \(score) points!"
            gameFinished = true
        }
    }
    
    func flagTapped(_ number: Int) {
        if number != correctAnswer {
            alertTitle =   "Yikesss! That's the flag of \(countries[number])"
            showingAlert = true
        } else {
            // Player tapped the correct flag -> +1pt
            score += 1
            countries.remove(at: number)
            continueGame()
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
                    .customTitleStyle()
                
                Spacer()
                Spacer()
                Text("Flag \(trialCounter)/\(playerMaxTries)")
                    .foregroundColor(.white)
                    .font(.title2.bold())
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
                            FlagImage(flagName: countries[number])
                        }
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("Continue", action: continueGame)
        } message: {
            Text(alertDescription)
        }
        .alert(alertTitle, isPresented: $gameFinished) {
            Button("Restart", action: resetGame)
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

struct FlagImage: View {
    var flagName: String
    
    var body: some View {
        Image(flagName).renderingMode(.original)
    }
}

struct CustomTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.white)
    }
}

extension View {
    func customTitleStyle() -> some View {
        modifier(CustomTitle())
    }
}
