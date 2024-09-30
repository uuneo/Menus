//
//  SharedData.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/29.
//

import SwiftUI

@Observable
class SharedData {
	/// This is used to create a custom Paging Indicator below the Photos ScrollView
	var activePage: Int = 1
	/// This is true when the Photos Grid ScrollView is Expanded
	var isExpanded: Bool = false
	/// MainScrollView Properties
	var mainOffset: CGFloat = 0
	var photosScrollOffset: CGFloat = 0
	var selectedCategory: String = "Years"
	var allowsInteraction: Bool = true
	/// These properties will be used to evaulate the drag conditions, whether the scroll view can be either be pulled up or down for expanding/minimising the photos scrollview
	var canPullUp: Bool = false
	var canPullDown: Bool = false
	var progress: CGFloat = 0
}
