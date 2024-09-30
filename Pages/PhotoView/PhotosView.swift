//
//  PhotosView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/22.
//

import SwiftUI


struct PhotosView: View {

	
	var body: some View {
		GeometryReader {
			let size = $0.size
			let safeArea = $0.safeAreaInsets
			
			HomePhotoView(size: size, safeArea: safeArea)
				.ignoresSafeArea(.all, edges: .top)
		}
		
	}
}

#Preview {
	PhotosView()
}
