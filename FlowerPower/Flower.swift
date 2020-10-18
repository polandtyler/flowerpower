//
//  Flower.swift
//  FlowerPower
//
//  Created by Tyler Poland on 10/18/20.
//

import SwiftUI

struct Flower: View {
    @Binding var isMinimized: Bool
    @Binding var numberOfPetals: Double
    @Binding var animationDuration: Double
    
    let circleDiameter: CGFloat = 80
    
    var color: Color = Color(UIColor.cyan).opacity(0.6)
    
    private var absolutePetalAngle: Double {
        return 360 / numberOfPetals
    }
    
    private var opacityPercentage: Double {
        let numberOfPetals = self.numberOfPetals.rounded(.down)
        let nextAngle = 360 / (numberOfPetals - 1)
        let currentAbsoluteAngle = 360 / numberOfPetals
        
        let totalTravel = currentAbsoluteAngle - nextAngle
        let currentProgress = absolutePetalAngle - nextAngle
        let percentage = currentProgress / totalTravel
        
        return 1 - percentage
    }
    
    var body: some View {
        ZStack() {
            ForEach(0...Int(numberOfPetals), id: \.self) {
                Circle()
                    .frame(width: self.circleDiameter, height: self.circleDiameter)
                    .foregroundColor(self.color)
                    .foregroundColor(Color(UIColor.cyan).opacity(0.6))
                    .rotationEffect(.degrees(self.absolutePetalAngle * Double($0)),
                                    anchor: self.isMinimized ? .center : .leading)
                    .opacity($0 == Int(self.numberOfPetals) ? self.opacityPercentage : 1)
            }
        }
        .offset(x: isMinimized ? 0 : circleDiameter / 2)
        .frame(width: circleDiameter * 2, height: circleDiameter * 2)
        
        .rotationEffect(.degrees(isMinimized ? -90 : 0))
        .scaleEffect(isMinimized ? 0.3 : 1)
        
        .animation(.easeInOut(duration: animationDuration))
        
        .rotationEffect(.degrees(-60))
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }
}

struct Flower_Previews: PreviewProvider {
    static var previews: some View {
        Flower(isMinimized: .constant(false),
               numberOfPetals: .constant(5),
               animationDuration: .constant(0.5))
    }
}
