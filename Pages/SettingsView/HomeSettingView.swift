//
//  HomeSettingView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/22.
//

import Defaults
import SwiftUI
import TipKit

struct HomeSettingView: View {

    var body: some View {
        ZStack {
            if ISPAD {
                SettingsView()
            } else {
                SettingsIphoneView()
            }
        }
        .environmentObject(peacock.shared)
        .scrollDismissesKeyboard(.interactively)
    }
}

#Preview {
    HomeSettingView()
        .environmentObject(peacock.shared)
}
