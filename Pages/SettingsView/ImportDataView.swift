//
//  ImportDataView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/8.
//

import CryptoKit
import SwiftUI
import UniformTypeIdentifiers

struct ImportDataView: View {
    @EnvironmentObject var manager: peacock
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    @State private var importData: String = ""
    @FocusState var isFocused: Bool
    @State private var importFile: Bool = false
//    @State private var totaldata: TotalRealmData?
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Button {
                        if !importData.isEmpty {
                            let success = manager.importData(text: importData)
                            if success {
                                alertTitle = "导入成功"
                                alertMessage = "数据导入成功"
                            } else {
                                alertTitle = "导入失败"
                                alertMessage = "数据导入失败"
                            }
                        }
                        showAlert.toggle()

                    } label: {
                        Text("导入数据")
                    }.buttonStyle(BorderedProminentButtonStyle())
                        .disabled(importData.isEmpty)
                }
            } header: {
                Text("文件导入优先级大于文字导入")
            }.listRowBackground(Color.clear)


            Section {
                TextEditor(text: $importData)
                    .focused($isFocused)
                    .frame(maxHeight: 500)
                    .fileImporter(isPresented: $importFile, allowedContentTypes: [.json]) { result in
                        switch result {
                        case .success(let fileURL):
                            // 检查文件是否位于沙盒之外，如果是，处理安全作用域
                            if fileURL.startAccessingSecurityScopedResource() {
                                do {
                                    // 读取文件数据
                                    let encryptedData = try String(contentsOf: fileURL, encoding: .utf8)
                                    self.importData = encryptedData

                                } catch {
                                    debugPrint(error.localizedDescription)
                                }
                            } else {
                                alertTitle = "无法访问文件"
                                self.showAlert.toggle()
                            }
                        case .failure:
                            alertTitle = "文件选择失败"
                            self.showAlert.toggle()
                        }
                    }

            } header: {
                HStack{
                    PasteButton(payloadType: String.self) { values in
                        if let value = values.first{
                            self.importData = value
                        }
                    }
                    Spacer()
                    Text("请将数据粘贴到这里")
                }
                
            }

        }
        .scrollDismissesKeyboard(.interactively)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .toolbar { 
            ToolbarItem(placement: .topBarTrailing) { 
                Button { 
                    importFile.toggle()
                } label: { 
                    Label { 
                        Text("导入数据")
                    } icon: { 
                        Image(systemName: "folder")
                    }

                }

            }
        }
    }
}

#Preview {
    ImportDataView()
        .environmentObject(peacock.shared)
}
