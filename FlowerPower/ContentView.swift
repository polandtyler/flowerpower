//
//  ContentView.swift
//  FlowerPower
//
//  Created by Tyler Poland on 10/18/20.
//

import SwiftUI

struct ContentView: View {
    @State private var numberOfPetals: Double = 5
    @State private var isMinimized: Bool = false
    @State private var animationDuration = petalDuration
    @State private var breathDuration = 4.2
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    private var fadeDuration: Double {
        return breathDuration * 0.6
    }
    
    static let petalDuration = 0.5
    
    var body: some View {
        List {
            Section {
                ZStack {
                    if isMinimized {
                        Flower(isMinimized: $isMinimized,
                               numberOfPetals: $numberOfPetals,
                               animationDuration: $animationDuration
                        ).transition(AnyTransition.asymmetric(
                                        insertion: AnyTransition.opacity.animation(Animation.default.delay(animationDuration)),
                                        removal: AnyTransition.blurFade.animation(Animation.easeIn(duration: fadeDuration)))
                        )
                        
                    }
                    
                    if colorScheme == .dark {
                    // secondary flower creates a mask around the main flower view
                        Flower(isMinimized: $isMinimized,
                               numberOfPetals: $numberOfPetals,
                               animationDuration: $animationDuration,
                               color: Color(UIColor.black)
                        )
                    }
                    
                    Flower(isMinimized: $isMinimized,
                           numberOfPetals: $numberOfPetals,
                           animationDuration: $animationDuration
                    )
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            }
            
            Section(header: Text("Number of petals: \(Int(numberOfPetals))")) {
                Slider(value: $numberOfPetals, in: 2...10) { onEditingChanged in
                    if !onEditingChanged {
                        self.numberOfPetals = self.numberOfPetals.rounded()
                    }
                }
            }
            
            Section(header: Text("Breathing duration: \(breathDuration)")) {
                Slider(value: $breathDuration, in: 0...10, step: 0.1)
            }
            
            Section {
                // breathe button
                Button(action: {
                    self.animationDuration = self.breathDuration
                    self.isMinimized.toggle()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration) {
                        self.isMinimized.toggle()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2 * self.animationDuration) {
                        self.animationDuration = ContentView.petalDuration
                    }
                }, label: {
                    Text("Breath")
                        .frame(maxWidth: .infinity)
                })
            }
            .buttonStyle(BorderlessButtonStyle())
            .foregroundColor(.white)
            .listRowBackground(Color(UIColor.systemBlue))
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
