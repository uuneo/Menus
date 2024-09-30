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
	
	@ObservedObject var audioManager:AudioPlayerManager = AudioPlayerManager.shard
	@State var isplaying:Bool = false
	
	var audioMusics:([URL],[URL]){
		audioManager.listFilesInDirectory()
	}
	
	var body: some View{
		ZStack{
			HStack{
				VStack{
					Spacer()
					ExpandedBottomSheet(expandSheet: $show, animation: animation,isPlaying: $isplaying)
					
				}
				.frame(width: UIScreen.main.bounds.width / 3)
				
				NavigationStack{
					VStack{
						
						List{
							ForEach(audioMusics.0, id: \.self){url in
								
								
								Button{
									if !isplaying{
										audioManager.stop()
									}
									
									isplaying = true
									
									audioManager.togglePlay( url)
									
									
								}label:{
									HStack{
										Label("\(url.deletingPathExtension().lastPathComponent)", systemImage: "arrowtriangle.right")
										Spacer()
										Image(systemName: "chevron.right")
											.padding(.trailing)
									}
									.padding()
									.background(.ultraThinMaterial)
									
								}
								.listRowBackground(Color.clear)
								
							}
						}
					}.navigationTitle("播放列表")
				}
				
				
				Spacer()
			}
		}
		
	}
	
	
}


#Preview {
	MusicView()
}
