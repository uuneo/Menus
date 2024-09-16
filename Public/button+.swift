//
//  button+.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import Foundation
import SwiftUI


struct MenuButton: View {
    
    @Binding var show: Bool
    
    var body: some View {
        return ZStack(alignment: .topTrailing) {
            Button(action: { self.show.toggle() }) {
                HStack {
                    Image(systemName: "list.dash")
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.leading, 18)
                .frame(width: 90, height: 60)
                .background(Color("button"))
                .cornerRadius(30)
                .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 20)
            }
            Spacer()
        }
    }
}
