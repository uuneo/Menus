//
//  AppIconView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/17.
//

import SwiftUI

struct AppIconView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("appdefaultlogo") var setting_active_app_icon:appIcon = .def
    @State var toastText = ""
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var body: some View {
        List{
            LazyVGrid(columns: columns){
				ForEach(Array(appIcon.arr), id: \.self){ item in
                  
                    ZStack{
                        Image(item.toLogoImage)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .circular))
                            .frame(width: 60,height:60)
                            .tag(item)
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(.largeTitle))
                            .scaleEffect(item == setting_active_app_icon ? 1 : 0.1)
                            .opacity(item == setting_active_app_icon ? 1 : 0)
                            .foregroundStyle(.green)
                        
                    }.animation(.spring, value: setting_active_app_icon)
                        .padding()
                            .listRowBackground(Color.clear)
                            .onTapGesture {
								setting_active_app_icon = item
                                let manager = UIApplication.shared
                                
                                var iconName:String? = manager.alternateIconName ?? appIcon.def.rawValue
                                
                                if setting_active_app_icon.rawValue == iconName{
                                    return
                                }
                                
                                if setting_active_app_icon != .def{
                                    iconName = setting_active_app_icon.rawValue
                                }else{
                                    iconName = nil
                                }
                                if UIApplication.shared.supportsAlternateIcons {
                                    Task{
                                        do {
                                            try await manager.setAlternateIconName(iconName)
                                        }catch{
#if DEBUG
                                            print(error)
#endif
                                            
                                        }
                                        DispatchQueue.main.async{
                                            dismiss()
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


enum appIcon:String,CaseIterable{
    case def = "AppIcon"
    case one = "AppIcon11"
    case two = "AppIcon12"
    case three = "AppIcon13"
    
    
    static let arr = Array(appIcon.allCases)
	
	static let allString = Array(appIcon.allCases.map{$0.rawValue})
    
    var toLogoImage: String{
        switch self {
        case .def:
            logoImage.def.rawValue
        case .one:
            logoImage.one.rawValue
        case .two:
            logoImage.two.rawValue
        case .three:
            logoImage.three.rawValue

        }
    }
}


enum logoImage:String,CaseIterable{
    
    case def = "logo"
    case one = "logo1"
    case two = "logo2"
    case three = "logo3"
    static let arr = Array(logoImage.allCases)
    
}
