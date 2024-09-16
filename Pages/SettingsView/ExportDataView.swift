//
//  ExportDataView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/8.
//

import SwiftUI

struct ExportDataView: View {

    @StateObject var manager = peacock.shared
    @State private var exportData:String = ""
    @State private var fileURL:URL?
    
    
    var body: some View {
        List{
            
            Text(exportData)
                .truncationMode(.tail)
            
        }.onAppear{
            self.exportData = manager.exportData()
            
        }.toolbar{
            ToolbarItem(placement: .topBarLeading) {
                
                
                if let file = manager.saveJSONToTempFile(object: manager.exportTotalData(), fileName: "menus"){
                    ShareLink(item: file){
                        Label("分享", systemImage: "square.and.arrow.up")
                    }
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
