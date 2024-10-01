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
			HStack{
				VStack{
					Spacer()
					ExpandedBottomSheet(expandSheet: $show, animation: animation)
					
				}
				.frame(width: UIScreen.main.bounds.width / 3)
				
				NavigationStack{
					VStack{
						
						List{
							ForEach(avManager.musics, id: \.self){url in
								
								
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
				
				
				Spacer()
			}
		}
		
	}
	
	
}


#Preview {
	MusicView()
}
