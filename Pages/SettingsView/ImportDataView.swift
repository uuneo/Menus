//
//  ImportDataView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/8.
//

import SwiftUI

struct ImportDataView: View {
    @StateObject var manager = peacock.shared
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    @State private var importData: String = ""
    @FocusState var isFocused: Bool
    var body: some View {
        List{
            Section{
                Button{
                   let success =  manager.importData(text: importData)
                    if success{
                        alertTitle = "导入成功"
                        alertMessage = "数据导入成功"
                    }else{
                        alertTitle = "导入失败"
                        alertMessage = "数据导入失败"
                    }
                    showAlert.toggle()
                    
                }label: {
                    Text("导入数据")
                }
            }
            

            Section{
                TextEditor(text: $importData)
                    .focused($isFocused)
                    .scrollDisabled(true)
             
                    
            }header: {
                Text("请将数据粘贴到这里")
            }
            .onAppear{
                isFocused = true
            }
           
           
        }.alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ImportDataView()
}
