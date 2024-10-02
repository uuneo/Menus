//
//   OtherContents.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/29.
//

import SwiftUI

struct OtherContents: View {
	@EnvironmentObject var shardData:SharedData
	var body: some View {
		VStack(spacing: 10) {
			DummyView("示例1", .yellow)
			DummyView("示例2", .blue)
			DummyView("示例3", .cyan)
			DummyView("示例4", .purple)
			DummyView("示例5", .pink)
		}
	}
	
	/// Dummy View with Title and Horizontal ScrollView
	@ViewBuilder
	func DummyView(_ title: String, _ color: Color) -> some View {
		VStack(alignment: .leading, spacing: 8) {
			Button {
				
			} label: {
				HStack(spacing: 6) {
					Text(title)
						.font(.title3.bold())
						.foregroundStyle(Color.primary)
					
					Image(systemName: "chevron.right")
						.font(.callout)
						.fontWeight(.semibold)
						.foregroundStyle(.gray)
				}
			}

			ScrollView(.horizontal) {
				LazyHStack(spacing: 10) {
					ForEach(1...10, id: \.self) {index in
						AsyncImageView(imageUrl: "https://picsum.photos/350/200?t=\(color)\(index * 10)")
							.frame(width: 300, height: 200)
							.onTapGesture {
								shardData.image = "https://picsum.photos/350/200?t=\(color)\(index * 10)"
								shardData.showDetail = true
							}
						
					}
				}
				.padding(.vertical, 10)
			}
		}
		.scrollIndicators(.hidden)
		.safeAreaPadding(.horizontal, 15)
		.padding(.top, 15)
	}
}
