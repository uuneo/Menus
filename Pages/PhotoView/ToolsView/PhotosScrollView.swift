//
//  PhotosScrollView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/29.
//

import SwiftUI

struct PhotosScrollView: View {
	var size: CGSize
	var safeArea: EdgeInsets
	@EnvironmentObject var sharedData:SharedData
	
	var column:Int{
		ISPAD ? 8 : 3
	}
	var body: some View {
		let screenHeight = size.height + safeArea.top + safeAreaBottom
		let minimisedHeight = screenHeight * 0.4
		
		ScrollViewReader { scrollReader in
			ScrollView(.horizontal) {
				/// By Default the alignment is center
				LazyHStack(alignment: .bottom, spacing: 0) {
					/// Grid Photos View
					GridPhotosScrollView()
					/// You can use ContainerRelativeFrame as well.
						.frame(width: size.width)
						.id(1)
					
					
					Group {
						
						StrechableView(600, 250,index: 1)
							.id(2)
						
						StrechableView(600, 250,index: 2)
							.id(3)
						
						StrechableView(600, 250,index: 3)
							.id(4)
					}
					.frame(height: screenHeight - minimisedHeight)
				}
				.scrollTargetLayout()
				/// Let's Give the indicator some Spacing
				.safeAreaPadding(.bottom, safeAreaBottom + 20)
			}
			/// Making it to stay at the same bottom place when the canPullUp property is true
			.offset(y: sharedData.canPullUp ? sharedData.photosScrollOffset : 0)
			.scrollClipDisabled()
			.scrollIndicators(.hidden)
			.scrollTargetBehavior(.paging)
			.scrollPosition(id: .init(get: {
				return sharedData.activePage
			}, set: {
				if let newValue = $0 { sharedData.activePage = newValue }
			}))
			/// Disabling the Horizontal Scroll Interaction, When the Photos Grid is Expanded
			.scrollDisabled(sharedData.isExpanded)
			.frame(height: screenHeight)
			/// Increasing the ScrollView Height based on the Progress
			.frame(height: screenHeight - (minimisedHeight - (minimisedHeight * sharedData.progress)), alignment: .bottom)
			.overlay(alignment: .bottom) {
				CustomPagingIndicatorView {
					Task {
						/// First checking if photos view is scrolled
						if sharedData.photosScrollOffset != 0 {
							/// If so, then resetting it first
							withAnimation(.easeInOut(duration: 0.15)) {
								scrollReader.scrollTo("SCROLLVIEW", anchor: .bottom)
							}
							
							try? await Task.sleep(for: .seconds(0.13))
						}
						
						/// Then Minimising the Expanded View
						withAnimation(.easeInOut(duration: 0.25)) {
							sharedData.progress = 0
							sharedData.isExpanded = false
						}
					}
				}
			}
		}
	}
	
	@ViewBuilder
	func GridPhotosScrollView() -> some View {
		/// Let's Make this scrollview to start from the bottom
		let progress = sharedData.progress
		ScrollView(.vertical) {
			LazyVGrid(columns: Array(repeating: GridItem(spacing: 2), count: column), spacing: 2) {
				ForEach(0...300, id: \.self) { index in
					
					AsyncImageView(imageUrl: "https://picsum.photos/200?t=\(index)")
						.aspectRatio(contentMode: .fit)
						.frame(height: size.width / CGFloat(column))
						.clipped()
					
					
				}
			}
			.padding(.top, safeArea.top + safeAreaBottom + 40)
			.visualEffect { content, _ in
				content
					.offset(y: progress * -(safeAreaBottom + 20))
			}
			.id("SCROLLVIEW")
			.onGeometryChange(for: CGFloat.self) {
				-($0.frame(in: .scrollView(axis: .vertical)).maxY - ($0.bounds(of: .scrollView(axis: .vertical))?.height ?? 0)).rounded()
			} action: { newValue in
				
				sharedData.photosScrollOffset = newValue
			}
		}
		.defaultScrollAnchor(.bottom)
		.scrollDisabled(!sharedData.isExpanded)
		.scrollClipDisabled()
	}
	
	/// Strechable Paging Views
	@ViewBuilder
	func StrechableView(_ width:Int, _ height: Int, index:Int) -> some View {
		/// Now, let's make it strechable
		GeometryReader {
			let minY = -sharedData.mainOffset
			let size = $0.size
			
			AsyncImageView(imageUrl: "https://picsum.photos/\(width)/\(height)?t=\(index * 30)")
				.aspectRatio(contentMode: .fit)
				.frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
				.offset(y: (minY > 0 ? -minY : 0))
		}
		.frame(width: size.width)
	}
	
	nonisolated
	var safeAreaBottom: CGFloat {
		/// For non-notch based iPhones the safe area bottom value is zero, in that case making sure it's a non zero value
		(safeArea.bottom == 0 ? 30 : safeArea.bottom)
	}
}
