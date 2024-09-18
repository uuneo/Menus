//
//  ContentView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/2.
//

import SwiftUI
import Defaults
import Pow

struct ContentView: View {
    
    var body: some View {
        

        NavigationStack{
            HomeView()
        }

    }
    
}








struct PriceSlide: View {
  @State
  var isPriceRevealed = false

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [.black, Color(red: 0.45, green: 0.45, blue: 0.52)],
        startPoint: .top,
        endPoint: .bottom
      )

    if isPriceRevealed {
        Text("$499")
          .transition(
             .identity
             .animation(.linear(duration: 1).delay(2))
             .combined(
               with: .movingParts.anvil
             )
          )
      } else {
          Text("$999")
            .transition(
              .asymmetric(
                insertion: .identity,
                removal: .opacity.animation(.easeOut(duration: 0.2)))
            )
      }
    }
    .font(.largeTitle.bold())
    .foregroundColor(.white)
    .contentShape(Rectangle())
    .onTapGesture {
      withAnimation {
        isPriceRevealed.toggle()
      }
    }
  }
}


#Preview {
    ContentView()
}
  
