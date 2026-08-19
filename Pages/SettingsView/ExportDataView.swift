//
//  ExportDataView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/8.
//

import SwiftUI

struct ExportDataView: View {
    @EnvironmentObject var manager: peacock

    @State private var exportData: String = "没有数据"
    @State private var fileURL: URL?

    var body: some View {
        List {

            Section {
                TextEditor(text: $exportData)
                    .frame(maxHeight: 500)
            } header: {
                Text("全部数据")
            }

        }
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            if let fileurl = fileURL {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(
                        item: fileurl,
                        preview: SharePreview(String("menus.json"), icon: "square.and.arrow.up")
                    )
                }
            }
        }
        .task {
            Task {
                let data = peacock.shared.exportTotalData()
                let file = peacock.shared.saveJSONToTempFile(
                    object: data,
                    fileName: "PeacockMenus-\(Date().yyyyMMddhhmmss())"
                )
                self.fileURL = file
                if let data = peacock.shared.exportData() {
                    self.exportData = data
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExportDataView()
            .environmentObject(peacock.shared)
    }
}
