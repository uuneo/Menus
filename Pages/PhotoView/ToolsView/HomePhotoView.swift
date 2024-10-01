//
//  HomePhotoView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/29.
//

import SwiftUI

struct HomePhotoView: View {
	var size: CGSize
	var safeArea: EdgeInsets
	
	@EnvironmentObject var sharedData:SharedData
	@State private var isMovingDown: Bool = false
	@State private var isGestureAdded: Bool = false
	@State private var translationValue: CGFloat = 0
	
	var body: some View {
		let minimisedHeight = (size.height + safeArea.top + safeArea.bottom) * 0.4
		let mainOffset = sharedData.mainOffset
		
		ScrollView(.vertical) {
			VStack(spacing: 10) {
				/// Photo Grid Scroll View
				PhotosScrollView(size: size, safeArea: safeArea)
				
				/// Other Bottom Contents (Like Albums, People, etc)
				OtherContents()
					.padding(.top, -30)
					.offset(y: sharedData.progress * 30)
			}
			/// This will make sure the scrollview is bounces from the top direction
			.offset(y: sharedData.canPullDown ? 0 : mainOffset < 0 ? -mainOffset : 0)
			.offset(y: mainOffset < 0 ? mainOffset : 0)
			.background {
				CustomSimulataneousGesture(isAdded: $isGestureAdded) { gesture in
					guard sharedData.activePage == 1 else { return }
					
					let state = gesture.state
					let translation = gesture.translation(in: gesture.view).y
					let isScrolling = state == .began || state == .changed
					
					let mainOffset = sharedData.mainOffset
					let photosScrollOffset = sharedData.photosScrollOffset
					
					
					if state == .began {
						sharedData.canPullDown = translation > 0 && (mainOffset >= 0 && mainOffset < 50)
						sharedData.canPullUp = translation < 0 && (photosScrollOffset >= 0 && photosScrollOffset < 50)
					}
					
					if isScrolling {
						/// Like onChanged Modifier in Drag Gesture
						if sharedData.canPullDown && !sharedData.isExpanded {
							let progress = max(min(translation / minimisedHeight, 1), 0)
							sharedData.progress = progress
						}
						
						if sharedData.canPullUp && sharedData.isExpanded {
							let progress = max(min(-translation / minimisedHeight, 1), 0)
							sharedData.progress = 1 - progress
						}
						
						translationValue = translation
					} else {
						/// Like onEnd Modifier in Drag Gesture
						withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
							if sharedData.canPullDown && !sharedData.isExpanded {
								if translation > 0 && isMovingDown {
									sharedData.isExpanded = true
									sharedData.progress = 1
								} else {
									sharedData.progress = 0
								}
							}
							
							if sharedData.canPullUp && sharedData.isExpanded {
								if translation < 0 && !isMovingDown {
									sharedData.isExpanded = false
									sharedData.progress = 0
								} else {
									sharedData.progress = 1
								}
							}
						}
					}
				}
			}
			.onGeometryChange(for: CGFloat.self) {
				-$0.frame(in: .scrollView(axis: .vertical)).minY.rounded()
			} action: { newValue in

				
				if newValue < -80{
					withAnimation(.easeInOut(duration: 0.25)) {
						sharedData.progress = 1
						sharedData.isExpanded = true
					}
				}
				
				sharedData.mainOffset = newValue
			}
		}
		.scrollBounceBehavior(.basedOnSize)
		/// Disabling the Main ScrollView Interaction, When the Photos Grid is Expanded
		.scrollDisabled(sharedData.isExpanded)
		.onChange(of: translationValue) { oldValue, newValue in
			isMovingDown = oldValue < newValue
		}
		.background(.gray.opacity(0.05))
	}
}


