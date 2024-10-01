//
//  TaskRowView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/30.
//

import SwiftUI
import Defaults

struct TaskRowView: View {
	@Binding var taskData: TaskData
	@Default(.books) var books
	
	@State private var showDeleView:Bool = false
	var body: some View {
		HStack(alignment: .top, spacing: 15) {
			Circle()
				.fill(indicatorColor)
				.frame(width: 10, height: 10)
				.padding(4)
				.background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
				.overlay {
					Circle()
						.frame(width: 50, height: 50)
						.blendMode(.destinationOver)
						.onTapGesture {
							withAnimation(.snappy) {
								taskData.isCompleted.toggle()
							}
						}
				}
			
			VStack(alignment: .leading, spacing: 8, content: {
				Text(taskData.taskTitle)
					.fontWeight(.semibold)
					.foregroundStyle(.black)
				
				Label(taskData.creationDate.format("hh:mm a"), systemImage: "clock")
					.font(.caption)
					.foregroundStyle(.black)
			})
			.padding(15)
			.hSpacing(.leading)
			.background(taskData.tint, in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
			.strikethrough(taskData.isCompleted, pattern: .solid, color: .black)
			.offset(y: -8)
			.onLongPressGesture {
				self.showDeleView.toggle()
			}
			
			.alert( isPresented: $showDeleView) {
				
				Alert(title: Text("确认删除？"), primaryButton: .destructive(Text("删除"), action: {
					if let index = books.firstIndex(where: {$0.id == taskData.id}){
						books.remove(at: index)
					}
				}), secondaryButton: .cancel())
				
			}
			
		}
		
	}
	
	var indicatorColor: Color {
		if taskData.isCompleted {
			return .green
		}
		
		return taskData.creationDate.isSameHour ? .darkBlue : (taskData.creationDate.isPast ? .red : .black)
	}
}
