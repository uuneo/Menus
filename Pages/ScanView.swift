//
//  ScanView.swift
//  Meow
//
//  Created by uuneo 2024/8/10.
//

import AVFoundation
import QRScanner
import SwiftUI
import UIKit

struct ScanView: View {
    @Environment(\.dismiss) var dismiss
    @State private var torchIsOn = false
    @State private var restart = false
    @State private var showActive = false
    @State private var isScanning = true
    @State private var manager = peacock.shared

    var response: (String) async -> Bool

    var config: QRScannerSwiftUIView.Configuration {
        .init(
            focusImage: nil,
            focusImagePadding: nil,
            animationDuration: nil,
            scanningAreaLimit: true,
            metadataObjectTypes: [.qr, .aztec, .microQR, .dataMatrix]
        )
    }

    var body: some View {
        ZStack {
            let config = QRScannerView.Input(
                focusImage: UIImage(named: "scan"),
                focusImagePadding: 20
            )

            QRScannerSwiftUIView(
                configuration: config,
                isScanning: $isScanning,
                torchActive: $torchIsOn,
                shouldRescan: $restart
            ) { code in
                Task {
                    if await response(code) {
                        self.dismiss()
                    } else {
                        self.showActive.toggle()
                    }
                }

            } onFailure: { error in
                switch error {
                case .unauthorized(let status):
                    if status != .authorized {
                        manager.toast("没有相机权限", mode: .error)
                    }
                    Task{@MainActor in 
                        self.dismiss()    
                    }
                default:
                    manager.toast("扫码失败", mode: .error)
                    Task{@MainActor in 
                        self.dismiss()
                    }
                }
            }
            .actionSheet(isPresented: $showActive) {
                ActionSheet(title: Text("扫码成功"), buttons: [
                    .default(Text("重新扫码"), action: {
                        self.showActive = false
                        self.restart.toggle()
                    }),
                    .cancel {
                        self.dismiss()
                    },
                ])
            }

            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .font(.title.bold())
                        .foregroundColor(.red)
                        .padding()
                        .background(.ultraThinMaterial, in: Circle())
                        // TODO: - 待修改
                        .onTapGesture {
                            self.dismiss()
                            Haptic.impact()
                        }
                        .offset(x: -30)
                }
                .padding()
                .padding(.top, 50)
                Spacer()

                VStack {
                    Image(systemName: torchIsOn ? "bolt" : "bolt.slash")
                        .scaleEffect(3)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.accent, .ultraThinMaterial)
                        .padding()
                        .VButton(onRelease: { _ in
                            self.torchIsOn.toggle()
                            return true
                        })
                }
                .padding(.bottom, 80)
            }
        }
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 30, coordinateSpace: .global)
                .onChanged { _ in
                    Haptic.selection()
                }
                .onEnded { action in
                    if action.translation.height > 100 {
                        manager.fullPage = false
                        Haptic.impact()
                    }
                }
        )
    }
}

#Preview {
    ScanView { _ in true }
}
