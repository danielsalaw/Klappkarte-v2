//
//  ContentView.swift
//  Klappkarte-v2
//
//  Created by Daniel on 22.06.20.
//  Copyright © 2020 Daniel Salaw. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    
    @State var countValue: Int = 0{
        didSet {
            if countValue < 0 {
                countValue = 0
            }
        }
    }
    @State var flipTrigger: Bool = false
    
    @State var swipeOffsetY: Double = 0.0
    @State var opacityBottomCard: Double = 0.75
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            

            // 🃏🔼 Karte oben
            ZStack {
                BaseCardView(upperHalf: true, displayedNumber: countValue + 1, tileColor: .green)
                    .opacity(opacityBottomCard)
                ForgroundTopCardView(currentNumber: countValue, offsetY: $swipeOffsetY)
            }
           
            
            // 🃏🔽 Karte unten
            ZStack {
                BaseCardView(upperHalf: false, displayedNumber: countValue - 1, tileColor: .green)
                    .opacity(0.75)
                 ForgroundBottomCardView(upperHalf: false, displayedNumber: flipTrigger ? countValue - 1 : countValue, tileColor: .green, backsideVisible: flipTrigger ? true : false, offsetY: $swipeOffsetY)
            }

        }.gesture(
            DragGesture()
                
                .onChanged({
                    action in
                    self.swipeOffsetY = Double(action.translation.height * 0.75)
                    
                    if self.swipeOffsetY < -90 {
                        self.flipTrigger = true
                    } else {
                        self.flipTrigger = false
                    }
                    
                    print("SwipeOffsetY: \(self.swipeOffsetY) \n FlipTrigger: \(self.flipTrigger) \n Opacity: \(self.opacityBottomCard) \n")
                    
                })
                
                .onEnded({
                    action in
                    let up = self.swipeOffsetY > 90.0
                    let down = self.swipeOffsetY < -90.0
                    
                    
                    
                    if up { self.countValue += 1 }
                    if down { self.countValue -= 1 }
                    
                    self.swipeOffsetY = 0.0 // reset
                    self.flipTrigger = false
                })
        )
//            .animation(
//            Animation
//                .spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0)
//        )
        
    }
}

struct BaseCardView: View {
    var upperHalf: Bool
    var displayedNumber: Int
    var tileColor: Color
    var backsideVisible: Bool = false
    
    var body: some View {
        // 🃏 Basiskarte Oben
        ZStack(alignment: upperHalf ? .top : .bottom) {
            
            //leerer Container für die Lücke
            Rectangle()
                .foregroundColor(.black).opacity(0)
                .frame(width: 131, height: 67)
            
            // 🃏 Karte mit Zahl
            ZStack {
                // 🃏 Kartenhälfte
                Rectangle()
                    .foregroundColor(tileColor)
                
                // 🃏 Zahl
                Text(String(displayedNumber))
                    .font(Font.system(size: 90 ,weight: .semibold, design: .monospaced))
                    .foregroundColor(Color("primaryColor"))
                    .padding(.top, upperHalf ? 67 : -67)
            }
            .frame(width: 131, height: 66)
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
        }
    }
}

struct  ForgroundBottomCardView: View {
    var upperHalf: Bool
    var displayedNumber: Int
    var tileColor: Color
    var backsideVisible: Bool = false
    @Binding var offsetY: Double
    
    var body: some View {
        // 🃏 Basiskarte Oben
        ZStack(alignment: upperHalf ? .top : .bottom) {
            
            //leerer Container für die Lücke
            Rectangle()
                .foregroundColor(.black).opacity(0)
                .frame(width: 131, height: 67)
            
            // 🃏 Karte mit Zahl
            ZStack {
                // 🃏 Kartenhälfte
                Rectangle()
                    .foregroundColor(tileColor)
                
                // 🃏 Zahl
                Text(String(displayedNumber))
                    .font(Font.system(size: 90 ,weight: .semibold, design: .monospaced))
                    .foregroundColor(Color("primaryColor"))
                    .padding(.top, backsideVisible ? 67 : -67)
                    .rotationEffect(.degrees(backsideVisible ? 180 : 0))
                    .rotation3DEffect(.degrees(backsideVisible ? 180 : 0), axis: (x: 0, y: backsideVisible ? 1 : 0, z: 0))
            }
            .frame(width: 131, height: 66)
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
        }
        .rotation3DEffect(Angle(degrees: min(max(0.0, -offsetY), 179.0)),
        axis: (x: 1.0, y: 0.0, z: 0.0),
        anchor: .top)
    }
}



struct ForgroundTopCardView: View {
    var currentNumber: Int
    @Binding var offsetY: Double
    
    var body: some View {
        BaseCardView(upperHalf: true, displayedNumber: currentNumber, tileColor: .red)
            .rotation3DEffect(Angle(degrees: min(max(-offsetY, -179), 0.0)),
                              axis: (x: 1.0, y: 0.0, z: 0.0),
                              anchor: .bottom)
    }
}






//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
