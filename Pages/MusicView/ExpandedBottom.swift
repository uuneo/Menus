//
//  ExpandedBottom.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/29.
//

import SwiftUI
import AVFoundation

struct ExpandedBottomSheet: View {
	@Binding var expandSheet: Bool
	var animation: Namespace.ID
	/// View Properties
	@State private var animateContent: Bool = false
	@State private var offsetY: CGFloat = 0
	
	@State private var audioPlayer: AVAudioPlayer?
	@Binding var isPlaying:Bool		 // 用来跟踪当前的播放状态
	@ObservedObject var audioManager:AudioPlayerManager = AudioPlayerManager.shard
	
	var audioMusics:([URL],[URL]){
		audioManager.listFilesInDirectory()
	}
	var body: some View {
		GeometryReader {
			let size = $0.size
			let safeArea = $0.safeAreaInsets
			let dragProgress = 1.0 - (offsetY / (size.height * 0.5))
			let cornerProgress = max(0, dragProgress)
			
			ZStack {
				/// Making it as Rounded Rectangle with Device Corner Radius
				RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius * cornerProgress : 0, style: .continuous)
					.fill(.ultraThickMaterial)
					.overlay(content: {
						RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius * cornerProgress : 0, style: .continuous)
							.fill(Color("BG"))
							.opacity(animateContent ? 1 : 0)
					})
					.overlay(alignment: .top) {
						MusicInfo(expandSheet: $expandSheet, animation: animation)
						/// Disabling Interaction (Since it's not Necessary Here)
							.allowsHitTesting(false)
							.opacity(animateContent ? 0 : 1)
					}
					.matchedGeometryEffect(id: "BGVIEW", in: animation)
				
				
				VStack(spacing: 15) {
					/// Grab Indicator
					Capsule()
						.fill(.gray)
						.frame(width: 40, height: 5)
						.opacity(animateContent ? cornerProgress : 0)
						/// Mathing with Slide Animation
						.offset(y: animateContent ? 0 : size.height)
						.clipped()
					
					/// Artwork Hero View
					GeometryReader {
						let size = $0.size
						
						Image("music")
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: size.width, height: size.height)
							.clipShape(RoundedRectangle(cornerRadius: animateContent ? 15 : 5, style: .continuous))
					}
					.matchedGeometryEffect(id: "ARTWORK", in: animation)
					/// For Square Artwork Image
					.frame(height: size.width - 50)
					/// For Smaller Devices the padding will be 10 and for larger devices the padding will be 30
					.padding(.vertical, size.height < 700 ? 10 : 30)
					
					/// Player View
					PlayerView(size)
					/// Moving it From Bottom
						.offset(y: animateContent ? 0 : size.height)
				}
				.padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
				.padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
				.padding(.horizontal, 25)
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
				.clipped()
			}
			.contentShape(Rectangle())
			.offset(y: offsetY)
//			.gesture(
//				DragGesture()
//					.onChanged({ value in
//						let translationY = value.translation.height
//						offsetY = (translationY > 0 ? translationY : 0)
//					}).onEnded({ value in
//						withAnimation(.easeInOut(duration: 0.3)) {
//							if (offsetY + (value.velocity.height * 0.3)) > size.height * 0.4 {
//								expandSheet = false
//								animateContent = false
//							} else {
//								offsetY = .zero
//							}
//						}
//					})
//			)
			.ignoresSafeArea(.container, edges: .all)
		}
		.onAppear {
			withAnimation(.easeInOut(duration: 0.35)) {
				animateContent = true
			}
		}
	}
	
	/// Player View (containing all the song information with playback controls)
	@ViewBuilder
	func PlayerView(_ mainSize: CGSize) -> some View {
		GeometryReader {
			let size = $0.size
			/// Dynamic Spacing Using Available Height
			let spacing = size.height * 0.04
			
			/// Sizing it for more compact look
			VStack(spacing: spacing) {
				VStack(spacing: spacing) {
					HStack(alignment: .center, spacing: 15) {
						VStack(alignment: .leading, spacing: 4) {
							Text("Look What You Made Me do")
								.font(.title3)
								.fontWeight(.semibold)
								.foregroundColor(.white)
							
							Text("Taylor Swift")
								.foregroundColor(.gray)
						}
						.frame(maxWidth: .infinity, alignment: .leading)
						
						Button {
							
						} label: {
							Image(systemName: "ellipsis")
								.foregroundColor(.white)
								.padding(12)
								.background {
									Circle()
										.fill(.ultraThinMaterial)
										.environment(\.colorScheme, .light)
								}
						}

					}
					
					/// Timing Indicator
					Capsule()
						.fill(.ultraThinMaterial)
						.environment(\.colorScheme, .light)
						.frame(height: 5)
						.padding(.top, spacing)
					
					/// Timing Label View
					HStack {
						Text("0:00")
							.font(.caption)
							.foregroundColor(.gray)
						
						Spacer(minLength: 0)
						
						Text("3:33")
							.font(.caption)
							.foregroundColor(.gray)
					}
				}
				/// Moving it to Top
				.frame(height: size.height / 2.5, alignment: .top)
				
				/// Playback Controls
				HStack(spacing: size.width * 0.18) {
					Button {
						
					} label: {
						Image(systemName: "backward.fill")
						/// Dynamic Sizing for Smaller to Larger iPhones
							.font(size.height < 300 ? .title3 : .title)
					}
					
					/// Making Play/Pause Little Bigger
					Button {
						if !isPlaying, let url = audioMusics.0.first
						{
							audioManager.togglePlay(url)
							isPlaying.toggle()
						}else{
							audioManager.stop()
							isPlaying.toggle()
						}
						
					} label: {
						Image(systemName: isPlaying ? "pause.fill" : "play.fill")
						/// Dynamic Sizing for Smaller to Larger iPhones
							.font(size.height < 300 ? .largeTitle : .system(size: 50))
					}
					
					Button {
						
					} label: {
						Image(systemName: "forward.fill")
						/// Dynamic Sizing for Smaller to Larger iPhones
							.font(size.height < 300 ? .title3 : .title)
					}
				}
				.foregroundColor(.white)
				.frame(maxHeight: .infinity)
				
				/// Volume & Other Controls
				VStack(spacing: spacing) {
					HStack(spacing: 15) {
						Image(systemName: "speaker.fill")
							.foregroundColor(.gray)
						
						Capsule()
							.fill(.ultraThinMaterial)
							.environment(\.colorScheme, .light)
							.frame(height: 5)
						
						Image(systemName: "speaker.wave.3.fill")
							.foregroundColor(.gray)
					}
					
					HStack(alignment: .top, spacing: size.width * 0.18) {
						Button {
							
						} label: {
							Image(systemName: "quote.bubble")
								.font(.title2)
						}
						
						VStack(spacing: 6) {
							Button {
								
							} label: {
								Image(systemName: "airpods.gen3")
									.font(.title2)
							}
							
							Text("iJustine's Airpods")
								.font(.caption)
						}
						
						Button {
							
						} label: {
							Image(systemName: "list.bullet")
								.font(.title2)
						}
					}
					.foregroundColor(.white)
					.blendMode(.overlay)
					.padding(.top, spacing)
				}
				/// Moving it to bottom
				.frame(height: size.height / 2.5, alignment: .bottom)
			}
		}
	}
	
}


/// Resuable File
struct MusicInfo: View {
	@Binding var expandSheet: Bool
	var animation: Namespace.ID
	var body: some View {
		HStack(spacing: 0) {
			/// Adding Matched Geometry Effect (Hero Animation)
			ZStack {
				if !expandSheet {
					GeometryReader {
						let size = $0.size
						
						Image("Artwork")
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: size.width, height: size.height)
							.clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 5, style: .continuous))
					}
					.matchedGeometryEffect(id: "ARTWORK", in: animation)
				}
			}
			.frame(width: 45, height: 45)
			
			Text("Look What You Made Me do")
				.fontWeight(.semibold)
				.lineLimit(1)
				.padding(.horizontal, 15)
			
			Spacer(minLength: 0)
			
			Button {
				
			} label: {
				Image(systemName: "pause.fill")
					.font(.title2)
			}
			
			Button {
				
			} label: {
				Image(systemName: "forward.fill")
					.font(.title2)
			}
			.padding(.leading, 25)
		}
		.foregroundColor(.primary)
		.padding(.horizontal)
		.padding(.bottom, 5)
		.frame(height: 70)
		.contentShape(Rectangle())
		.onTapGesture {
			/// Expanding Bottom Sheet
			withAnimation(.easeInOut(duration: 0.3)) {
				expandSheet = true
			}
		}
	}
}


#Preview{
	MusicView()
}
