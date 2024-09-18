//
//  ExportDataView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/8.
//

import SwiftUI

struct ExportDataView: View {

    @StateObject var manager = peacock.shared
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
                
                
                if let file = fileURL{
                    ShareLink(item: file){
                        Label("分享", systemImage: "square.and.arrow.up")
                    }
                }
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
    }
   
}
