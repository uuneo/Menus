//
//  ImportDataView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/8.
//

import SwiftUI
import UniformTypeIdentifiers

struct ImportDataView: View {
    @StateObject var manager = peacock.shared
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    @State private var importData: String = ""
    @FocusState var isFocused: Bool
    @State private var importFile:Bool = false
    
    @State private var fileUrl:URL?
    var body: some View {
        List{
            
            Section{
                HStack{
                    Spacer()
                    Button{
                        if !importData.isEmpty{
                            let success =  manager.importData(text: importData)
                             if success{
                                 alertTitle = "导入成功"
                                 alertMessage = "数据导入成功"
                             }else{
                                 alertTitle = "导入失败"
                                 alertMessage = "数据导入失败"
                             }
                        }
                        
                        
                        if let url = fileUrl{
                            let success =  manager.importData(url: url)
                            if success{
                                alertTitle = "导入成功"
                                alertMessage = "数据导入成功"
                            }else{
                                alertTitle = "导入失败"
                                alertMessage = "数据导入失败"
                            }
                        }
                        
                        showAlert.toggle()
                        
                    }label: {
                        Text("导入数据")
                    }.buttonStyle(BorderedProminentButtonStyle())
                    .disabled(importData.isEmpty && fileUrl == nil)
                    
                }
            }header: {
                Text("文件导入优先级大于文字导入")
            }.listRowBackground(Color.clear)
            
            Section{
                HStack{
                   
                    if let fileUrl = fileUrl{
                        
                        Button{
                            self.fileUrl = nil
                        }label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                        }.accentColor(.secondary)
                        
                        
                        Spacer()
                        Text(fileUrl.lastPathComponent)
                            .foregroundColor(.secondary)
                            .padding(.leading, 10)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .font(.title3)
                            .minimumScaleFactor(0.5)
                       
                       
                    }else{
                        
                        Button{
                            importFile.toggle()
                        }label: {
                            Text("选择文件")
                        }.buttonStyle(BorderedProminentButtonStyle())
                        
                    }
                    
                    
                    
                }
                
                
                .fileImporter(isPresented: $importFile, allowedContentTypes: [UTType.json]) { result in
                    switch result {
                    case .success(let success):
                        self.fileUrl = success
                    case .failure(_):
                        alertTitle = "文件选择失败"
                    }
                }
            }header: {
                Text("只能导入.json文件")
            }
            
           
          
           

            Section{
                TextEditor(text: $importData)
                    .focused($isFocused)
                    .scrollDisabled(true)
             
                    
            }header: {
                Text("请将数据粘贴到这里")
            }
           
        }.alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    
}

#Preview {
    ImportDataView()
}
