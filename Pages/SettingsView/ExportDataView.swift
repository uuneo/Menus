//
//  ExportDataView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/8.
//

import SwiftUI

struct ExportDataView: View {
	@EnvironmentObject var manager:peacock

    @State private var exportData:String = "没有数据"
    @State private var fileURL:URL?
    @State private var isEditing:Bool = false
    
    var body: some View {
        List{
            Section{
                Button{
                    self.isEditing.toggle()
                }label: {
                    Text(isEditing ? "完成" : "编辑")
                }.buttonStyle(BorderedProminentButtonStyle())
            }.listRowBackground(Color.clear)
            
//            编辑
            Section{
                TextEditor(text: $exportData)
                    .frame(maxHeight: 500)
                    .truncationMode(.tail)
                    .disabled(!isEditing)
            }header: {
                Text("全部数据")
            }
           
            
        }.toolbar{
            ToolbarItem(placement: .topBarLeading) {
                
				ShareLink(item:manager.exportTotalData(),preview: SharePreview("分享", icon: "square.and.arrow.up"))
		
            }
        }.task {
            DispatchQueue.global(qos: .background).async {
                let data = peacock.shared.exportTotalData()
                let file =  peacock.shared.saveJSONToTempFile(object: data, fileName: "menus")
                DispatchQueue.main.async {
                    self.fileURL = file
                    self.exportData = peacock.shared.exportData()
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        ExportDataView()
			.environmentObject(peacock.shared)
    }
   
}
