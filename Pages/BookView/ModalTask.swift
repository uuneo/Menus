//
//  ModalTask.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/30.
//
import SwiftUI


//struct TaskData: Identifiable {
//	var id: UUID = .init()
//	var taskTitle: String
//	var creationDate: Date = .init()
//	var isCompleted: Bool = false
//	var tint: Color
//}

var sampleTasks: [TaskData] = [
	.init(taskTitle: "Record Video", creationDate: .updateHour(-1), isCompleted: true, tint: .taskColor1),
	.init(taskTitle: "Redesign Website", creationDate: .updateHour(9), tint: .taskColor2),
	.init(taskTitle: "Go for a Walk", creationDate: .updateHour(10), tint: .taskColor3),
	.init(taskTitle: "Edit Video", creationDate: .updateHour(0), tint: .taskColor4),
	.init(taskTitle: "Publish Video", creationDate: .updateHour(2), tint: .taskColor1),
	.init(taskTitle: "Tweet about new Video!", creationDate: .updateHour(12), tint: .taskColor5),
]

extension Date {
	static func updateHour(_ value: Int) -> Date {
		let calendar = Calendar.current
		return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
	}
	
	/// Custom Date Format
	func format(_ format: String) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		
		return formatter.string(from: self)
	}
	
	/// Checking Whether the Date is Today
	var isToday: Bool {
		return Calendar.current.isDateInToday(self)
	}
	
	/// Checking if the date is Same Hour
	var isSameHour: Bool {
		return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedSame
	}
	
	/// Checking if the date is Past Hours
	var isPast: Bool {
		return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedAscending
	}
	
	/// Fetching Week Based on given Date
	func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
		let calendar = Calendar.current
		let startOfDate = calendar.startOfDay(for: date)
		
		var week: [WeekDay] = []
		let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
		guard let starOfWeek = weekForDate?.start else {
			return []
		}
		
		/// Iterating to get the Full Week
		(0..<7).forEach { index in
			if let weekDay = calendar.date(byAdding: .day, value: index, to: starOfWeek) {
				week.append(.init(date: weekDay))
			}
		}
		
		return week
	}
	
	/// Creating Next Week, based on the Last Current Week's Date
	func createNextWeek() -> [WeekDay] {
		let calendar = Calendar.current
		let startOfLastDate = calendar.startOfDay(for: self)
		guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
			return []
		}
		
		return fetchWeek(nextDate)
	}
	
	/// Creating Previous Week, based on the First Current Week's Date
	func createPreviousWeek() -> [WeekDay] {
		let calendar = Calendar.current
		let startOfFirstDate = calendar.startOfDay(for: self)
		guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
			return []
		}
		
		return fetchWeek(previousDate)
	}
	
	struct WeekDay: Identifiable {
		var id: UUID = .init()
		var date: Date
	}
}



/// Custom View Extensions
extension View {
	/// Custom Spacers
	@ViewBuilder
	func hSpacing(_ alignment: Alignment) -> some View {
		self
			.frame(maxWidth: .infinity, alignment: alignment)
	}
	
	@ViewBuilder
	func vSpacing(_ alignment: Alignment) -> some View {
		self
			.frame(maxHeight: .infinity, alignment: alignment)
	}
	
	/// Checking Two dates are same
	func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
		return Calendar.current.isDate(date1, inSameDayAs: date2)
	}
}


struct OffsetKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}
