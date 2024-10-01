//
//  PhotosView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/22.
//

import SwiftUI


struct PhotosView: View {

	@ObservedObject var sharedData = SharedData.shared
	
	var body: some View {
		GeometryReader {
			HomePhotoView(size: $0.size, safeArea: $0.safeAreaInsets)
				.ignoresSafeArea(.all, edges: .top)
				.environmentObject(sharedData)
			
		}
		
	}
}

#Preview {
	PhotosView()
		.environmentObject(SharedData.shared)
}
