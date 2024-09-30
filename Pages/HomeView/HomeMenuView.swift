//
//  HomeMenuView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/29.
//

import SwiftUI
import Lottie


struct HomeMenuView: View {
	@EnvironmentObject var manager:peacock
	
	@State var animationMode:LottieLoopMode = .repeat(2)
	var body: some View {
		Grid( horizontalSpacing: 50, verticalSpacing: 50){
			GridRow{
				
				Button{
					manager.page = .book
				}label: {
					
					ZStack(alignment: .top){
						LottieView(animation: .named("contact"))
							
							.playing(loopMode: animationMode)
							.animationDidFinish{ proxy in
								debugPrint(proxy)
							}
							
							.aspectRatio(contentMode: .fill)
							.scaleEffect(1.3)
							.offset(x: 30,y: 70)
						VStack{
							Text("预约服务")
								.font(.system(size: 45))
							
							Text("Make a reservation")
								.foregroundStyle(.quaternary)
							Spacer()
						}
						.shadow(radius: 5)
						
					}
					.accentColor(.black)
					.padding()
					.frame(width: 300, height: 300)
					.background( .ultraThinMaterial )
					.containerShape(RoundedRectangle(cornerRadius: 20))
				
						
				}
				
				
				
				
				FlipClockTextEffectMock()
					.padding(30)
					.frame(width: 500, height: 300)
					.background(
						.ultraThinMaterial
					)
					.clipShape(RoundedRectangle(cornerRadius: 20))
					.background(content: {
						Color.clear
							.shadow(color: .gray.opacity(0.5), radius: 10, x: 10, y: 10)
							.shadow(color: .white, radius: 2, x: -1, y: -1)
					})
					.gridCellUnsizedAxes(.horizontal)
					.gridCellColumns(2)
				
			}
			
			
			GridRow{
				
				
				Button{
					manager.page = .photo
				}label: {
					
					ZStack(alignment: .top){
						LottieView(animation: .named("album"))
							.playing(loopMode: animationMode)
							.aspectRatio(contentMode: .fill)
							.offset(x: 20)
						
						VStack{
							
							
							Spacer()
							
							HStack{
								
								
								VStack{
									Text("图库")
										.font(.system(size: 35))
									
									Text("Photo Album")
										.foregroundStyle(.quaternary)
								}
								.shadow(radius: 5)
								Spacer()
							}
							
							
							
						}
						
						
					}
					.accentColor(.black)
					.padding()
					.frame(width: 300, height: 300)
					.background( .ultraThinMaterial )
					.containerShape(RoundedRectangle(cornerRadius: 20))
				
						
				}
				
				
				Button{
					manager.page = .music
				}label: {
					
					ZStack(alignment: .top){
						LottieView(animation: .named("music"))
							.playing(loopMode: animationMode)
							.aspectRatio(contentMode: .fill)
							.offset( y: -50)
						
						VStack{
							
							
							Spacer()
							
							HStack{
								
								
								VStack{
									Text("背景音乐")
										.font(.system(size: 35))
									
									Text("Music")
										.foregroundStyle(.quaternary)
								}
								.shadow(radius: 5)
								Spacer()
							}
							
							
							
						}
						
						
					}
					.accentColor(.black)
					.padding()
					.frame(width: 300, height: 300)
					.background( .ultraThinMaterial )
					.containerShape(RoundedRectangle(cornerRadius: 20))
				
						
				}
				
				Button{
					withAnimation {
						manager.page = .menu
					}
				
				}label: {
					
					ZStack(alignment: .top){
						LottieView(animation: .named("menus"))
							.playing(loopMode: .loop)
							.aspectRatio(contentMode: .fill)
							.offset( y: -50)
						
						VStack{
							
							
							Spacer()
							
							HStack{
								
								
								VStack{
									Text("价目表")
										.font(.system(size: 35))
									
									Text("Menu Price")
										.foregroundStyle(.quaternary)
								}
								.shadow(radius: 5)
								Spacer()
							}
							
							
							
						}
						
						
					}
					.accentColor(.black)
					.padding()
					.frame(width: 300, height: 300)
					.background( .ultraThinMaterial )
					.containerShape(RoundedRectangle(cornerRadius: 20))
					.shadow(color: .black.opacity(0.3), radius: 10, x: 10, y: 10)
				
						
				}
				
				
			}
			.frame(maxHeight: 300)
		}
		.padding()
		.frame(width: UIScreen.main.bounds.width)
		
	}
}


#Preview{
	HomeMenuView()
		.environmentObject(peacock.shared)
}
