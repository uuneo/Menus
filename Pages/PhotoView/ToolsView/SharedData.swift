//
//  SharedData.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/29.
//

import SwiftUI


class SharedData: ObservableObject {
	static let shared = SharedData()
	
	private init(){}
	
	/// This is used to create a custom Paging Indicator below the Photos ScrollView
	
	@Published var activePage: Int = 1
	/// This is true when the Photos Grid ScrollView is Expanded
	@Published var isExpanded: Bool = false
	/// MainScrollView Properties
	@Published var mainOffset: CGFloat = 0
	@Published var photosScrollOffset: CGFloat = 0
	@Published var selectedCategory: String = "Years"
	@Published var allowsInteraction: Bool = true
	/// These properties will be used to evaulate the drag conditions, whether the scroll view can be either be pulled up or down for expanding/minimising the photos scrollview
	@Published var canPullUp: Bool = false
	@Published var canPullDown: Bool = false
	@Published var progress: CGFloat = 0
	
	@Published var showDetail:Bool = false
	@Published var image:String = ""
}
