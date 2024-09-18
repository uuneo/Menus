//
//  BasicSettingsView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/16.
//

import SwiftUI
import Defaults

struct BasicSettingsView: View {
    
    @State private var selectedTab:Int? = 0
    @Binding var columnVisibility: NavigationSplitViewVisibility
    @State private var showAlert:Bool = false
    @State private var showIconPicker:Bool = false
    var body: some View {
        NavigationStack{
            List(selection: $selectedTab){
                
                NavigationLink{
                    AppSettings()
                        .navigationTitle("App设置")
                }label: {
                    Label("App设置", systemImage: "house.circle")
                }
                
                .tag(1)
                
                
                
                NavigationLink{
                    ExportDataView()
                        .navigationTitle("导出信息")
                }label: {
                    Label("导出信息", systemImage: "square.and.arrow.up")
                }
                
                .tag(2)
                
                NavigationLink{
                    ImportDataView()
                        .navigationTitle("导入信息")
                }label: {
                    Label("导入信息", systemImage: "square.and.arrow.down")
                }
                
                .tag(3)
                
                Button{
                    self.showIconPicker.toggle()
                }label:{
                   
                   Label("切换图标", systemImage: "photo.circle")
                }
                .sheet(isPresented: $showIconPicker) {
                    NavigationStack{
                        AppIconView()
                    }.presentationDetents([.medium])
                }
        
                
                
                
            }.navigationTitle("通用设置")
                .onChange(of: selectedTab) { _, _ in
                    self.columnVisibility = .doubleColumn
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("恢复初始化"), message: Text("是否确定恢复初始化"), primaryButton: .destructive(Text("确定"), action: {
                        Defaults.reset(.cards,.categoryItems,.subcategoryItems,.items, .settingPassword)
                    }), secondaryButton: .cancel())
                }
                .toolbar{
                    ToolbarItem {
                        Button{
                            showAlert = true
                        }label: {
                            Label("恢复初始化", systemImage: "point.forward.to.point.capsulepath")
                        }
                    }
                }
            
        }
    }
}

#Preview {
    BasicSettingsView(columnVisibility:.constant(.doubleColumn))
}
