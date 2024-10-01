
//
//  BookModal.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/10/1.
//

import Defaults
import SwiftUI


struct TaskData: Identifiable, Codable, Defaults.Serializable{

	var id: UUID = .init()
	var taskTitle: String
	var creationDate: Date = .init()
	var isCompleted: Bool = false
	var tint: Color
	
}



extension Defaults.Keys{
	
	static let books = Key<[TaskData]>("books",default: [])
	
}


extension Date {
	
	// 将日期格式化为年-月-日的字符串形式
	func formattedDate() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter.string(from: self)
	}
}




// 扩展 Color，使其支持 Codable
extension Color: Codable {
	enum CodingKeys: String, CodingKey {
		case red, green, blue, opacity
	}
	
	// 编码 Color 为 RGBA 值
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		let uiColor = UIColor(self)
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		
		uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		
		try container.encode(Double(red), forKey: .red)
		try container.encode(Double(green), forKey: .green)
		try container.encode(Double(blue), forKey: .blue)
		try container.encode(Double(alpha), forKey: .opacity)
	}
	
	// 解码为 Color 对象
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let red = try container.decode(Double.self, forKey: .red)
		let green = try container.decode(Double.self, forKey: .green)
		let blue = try container.decode(Double.self, forKey: .blue)
		let opacity = try container.decode(Double.self, forKey: .opacity)
		
		self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
	}
}
