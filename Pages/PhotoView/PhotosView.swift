//
//  PhotosView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/22.
//

import SwiftUI

struct PhotosView: View {
    var body: some View {
		NavigationStack{
			ZStack{
				Image("card5")
					.resizable()
					.scaledToFill()
					.edgesIgnoringSafeArea(.all)
					.blur(radius: 10)
					.scaleEffect(1.1)
					
					
				Text("一次相遇，终身美好")
					.font(.largeTitle)
					.padding()
					.foregroundStyle(.linearGradient(colors: [.green,.pink,.blue,.orange], startPoint: .topLeading, endPoint: .bottomTrailing))
				
			}
			
				
		}
    }
}

#Preview {
    PhotosView()
}
