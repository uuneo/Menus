//
//  AppIconView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/17.
//

import SwiftUI



enum appIcon:String,CaseIterable{
	case def = "AppIcon"
	case one = "AppIcon1"
	case two = "AppIcon2"
	case three = "AppIcon3"
	
	
	static let arr = Array(appIcon.allCases)
	
	var toLogoImage: String{
		switch self {
		case .def:
			"logo"
		case .one:
			"logo1"
		case .two:
			"logo2"
		case .three:
			"logo3"
			
		}
	}
}



struct AppIconView: View {
	@Environment(\.dismiss) var dismiss
	@AppStorage("appdefaultlogo") var setting_active_app_icon:appIcon = .def
	@State var toastText = ""
	let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
	var body: some View {
		List{
			LazyVGrid(columns: columns){
				ForEach(appIcon.arr, id: \.self){ item in
					
					ZStack{
						Image(item.toLogoImage)
							.resizable()
							.clipShape(RoundedRectangle(cornerRadius: 20, style: .circular))
							.frame(width: 60,height:60)
						
						Image(systemName: "checkmark.seal.fill")
							.font(.system(.largeTitle))
							.scaleEffect(item == setting_active_app_icon ? 1 : 0.1)
							.opacity(item == setting_active_app_icon ? 1 : 0)
							.foregroundStyle(.green)
						
					}.animation(.spring, value: setting_active_app_icon)
						.padding()
						.listRowBackground(Color.clear)
						.onTapGesture {
							
							let manager = UIApplication.shared
							
							
							
							if item.rawValue == manager.alternateIconName{
								dismiss()
								return
							}
							
							if UIApplication.shared.supportsAlternateIcons {
								Task{
									do {
										try await manager.setAlternateIconName(item.rawValue)
										
										DispatchQueue.main.async{
											self.setting_active_app_icon = item
											dismiss()
										}
									}catch{
										
										debugPrint("\(item.rawValue)",error)
										
									}
								
								}
								
							}
						}
					
					
				}
			}
			.listRowBackground(Color.clear)
			.listRowSeparatorTint(Color.clear)
		}
		.listStyle(GroupedListStyle())
		
		.navigationTitle("更换图标")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar{
			ToolbarItem{
				Button{
					self.dismiss()
				}label:{
					Image(systemName: "xmark.seal")
				}
				
			}
		}
		
	}
}

#Preview {
	AppIconView()
}


