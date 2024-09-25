//
//  SettingTipView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/25.
//

import TipKit
import Defaults


struct UploadTipView: Tip{
	var title: Text{
		Text("提示")
			.bold()
	}
	
	var message: Text?{
		Text("修改完成后点击按钮可以上传信息到服务器")
			.font(.headline)
			.foregroundStyle(.gray.gradient)
		
	}
	
	var image: Image?{
		Image(systemName: "icloud.and.arrow.up")
	}
	
	var rules: [Rule] {
		#Rule(Self.$startTipHasDisplayed) { $0 == true}
	}
	
	@Parameter
	static var startTipHasDisplayed: Bool = false
}


struct InitializeDataView: Tip{
	var title: Text{
		Text("数据初始化")
			.bold()
	}
	
	var message: Text?{
		Text("恢复数据到初始状态")
			.font(.headline)
			.foregroundStyle(.gray.gradient)
	}
	
	var image: Image?{
		Image(systemName: "exclamationmark.arrow.circlepath")
	}
	
	var rules: [Rule] {
		#Rule(Self.$startTipHasDisplayed) { $0 == true}
	}
	
	@Parameter
	static var startTipHasDisplayed: Bool = false
}


struct SettingTipView: Tip{
	var title: Text{
		Text("打开设置")
			.bold()
	}
	
	var message: Text?{
		Text("编辑APP数据")
			.font(.headline)
			.foregroundStyle(.gray.gradient)
	}
	
	var image: Image?{
		Image(systemName: "gear.circle")
	}
	
	var rules: [Rule] {
		#Rule(Self.$startTipHasDisplayed) { $0 == true}
	}
	
	@Parameter
	static var startTipHasDisplayed: Bool = false
}


struct DiscountTipView: Tip{
	var title: Text{
		Text("提示")
			.bold()
	}
	
	var message: Text?{
		Text("点击可以切换折扣")
			.font(.headline)
			.foregroundStyle(.gray.gradient)
	}
	
	var image: Image?{
		Image(systemName: "creditcard")
	}
	
	var rules: [Rule] {
		#Rule(Self.$startTipHasDisplayed) { $0 == true}
	}
	
	@Parameter
	static var startTipHasDisplayed: Bool = false
}

struct EditChangeTipView: Tip{
	var title: Text{
		Text("提示")
			.bold()
	}
	
	var message: Text?{
		Text(
			"""
	修改数据后将实时保存在本地
	不需要任何保存动作
"""
		)
			.font(.headline)
			.foregroundStyle(.gray.gradient)
	}
	
	var image: Image?{
		Image(systemName: "slider.vertical.3")
	}
}
