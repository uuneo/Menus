//
//  MusicView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/29.
//

import SwiftUI

struct MusicView: View {
	@State private var expandSheet: Bool = false
	@State private var hideTabBar: Bool = false
	@Namespace private var animation
	@State private var show:Bool = true
	
	@ObservedObject var avManager:AvManager = AvManager.shared
	
	@State private var showImport:Bool = false
	@State private var selectUrl:URL?
	
	var body: some View{
		ZStack{
			if ISPAD{
				IpadMusicView()
			}else{
				IphoneMusicView()
			}
		}
		.environmentObject(avManager)
		
	}
	
	
	@ViewBuilder
	func IphoneMusicView() -> some View{
		
		TabView {
			MusicList(avManager.examples)
				.setTabItem("示例", "dot.radiowaves.left.and.right")
				.setTabBarBackground(.init(.ultraThickMaterial))
				.hideTabBar(hideTabBar)
			MusicList(avManager.musics)
				.setTabItem("播放列表", "play.circle.fill")
		}
		
		
		.safeAreaInset(edge: .bottom) {
			CustomBottomSheet()
		}
		.overlay {
			if expandSheet {
				ExpandedBottomSheet(expandSheet: $expandSheet, animation: animation)
				/// Transition for more fluent Animation
					.transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
			}
		}
		.onChange(of: expandSheet) {_, newValue in
			/// Delaying a Little Bit for Hiding the Tab Bar
			DispatchQueue.main.asyncAfter(deadline: .now() + (newValue ? 0.04 : 0.03)) {
				withAnimation(.easeInOut(duration: 0.3)) {
					hideTabBar = newValue
				}
			}
		}
	}
	
	
	@ViewBuilder
	func IpadMusicView()-> some View{
		HStack{
			ExpandedBottomSheet(expandSheet: $show, animation: animation)
				.frame(width: UIScreen.main.bounds.width / 3)
			
			NavigationStack{
				MusicList(avManager.musics)
			}
		}
	}
	
	@ViewBuilder
	func MusicList(_ musics: [URL])-> some View{
		
		VStack{
			
			List{
				ForEach(musics, id: \.self){url in
					
					
					Button{
						_ = avManager.play(url: url)
					}label:{
						HStack{
							Label("\(url.deletingPathExtension().lastPathComponent)", systemImage: "megaphone")
							Spacer()
							Image(systemName: "chevron.right")
								.padding(.trailing)
						}
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 30)
								.fill(avManager.currentlyPlayingURL == url ? Color.gray.opacity(0.3) : Color.clear)
							
							
						)
						.background( .ultraThinMaterial )
						
						
					}
					.listRowBackground( Color.clear)
					
				}
				.onDelete { index in
					for k in index{
						avManager.deleteSound(url: avManager.musics[k])
					}
					avManager.updateMusics()
				}
				
			}.refreshable {
				avManager.updateMusics()
			}
			
		}
		.navigationTitle("播放列表")
		.toolbar {
			ToolbarItem {
				Button{
					self.showImport.toggle()
				}label:{
					Image(systemName: "square.and.arrow.down")
				}
				.fileImporter(isPresented: $showImport, allowedContentTypes: [.audio]) { result in
					switch result {
					case .success(let fileUrl):
						if fileUrl.startAccessingSecurityScopedResource() {
							avManager.saveSound(url: fileUrl)
							
						}
					case .failure(let err):
						debugPrint(err)
					}
				}
			}
			
		}
		
	}
	
	/// Custom Bottom Sheet
	@ViewBuilder
	func CustomBottomSheet() -> some View {
		/// Animating Sheet Background (To Look Like It's Expanding From the Bottom)
		ZStack {
			if expandSheet {
				Rectangle()
					.fill(.clear)
			} else {
				Rectangle()
					.fill(.ultraThickMaterial)
					.overlay {
						/// Music Info
						MusicInfo(expandSheet: $expandSheet, animation: animation)
					}
					.matchedGeometryEffect(id: "BGVIEW", in: animation)
			}
		}
		.frame(height: 70)
		/// Separator Line
		.overlay(alignment: .bottom, content: {
			Rectangle()
				.fill(.gray.opacity(0.3))
				.frame(height: 1)
		})
		/// 49: Default Tab Bar Height
		.offset(y: -49)
	}
	
	/// Generates Sample View with Tab Label
	@ViewBuilder
	func SampleTab(_ title: String, _ icon: String) -> some View {
		/// iOS Bug, It can be Avoided by wrapping the view inside ScrollView
		ScrollView(.vertical, showsIndicators: false, content: {
			Text(title)
				.padding(.top, 25)
		})
		.setTabItem(title, icon)
		/// Changing Tab Background Color
		.setTabBarBackground(.init(.ultraThickMaterial))
		/// Hiding Tab Bar When Sheet is Expanded
		.hideTabBar(hideTabBar)
	}
	
	
}

/// Custom View Modifier's
extension View {
	@ViewBuilder
	func setTabItem(_ title: String, _ icon: String) -> some View {
		self
			.tabItem {
				Image(systemName: icon)
				Text(title)
			}
	}
	
	@ViewBuilder
	func setTabBarBackground(_ style: AnyShapeStyle) -> some View {
		self
			.toolbarBackground(.visible, for: .tabBar)
			.toolbarBackground(style, for: .tabBar)
	}
	
	@ViewBuilder
	func hideTabBar(_ status: Bool) -> some View {
		self
			.toolbar(status ? .hidden : .visible, for: .tabBar)
	}
}



#Preview {
	MusicView()
		.environmentObject(AvManager.shared)
}
