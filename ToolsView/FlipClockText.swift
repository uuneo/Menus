//
//  FlipClockText.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/28.
//

import SwiftUI

struct FlipClockTextEffect: View {
	@Binding var value: Int
	/// Config
	var size: CGSize
	var fontSize: CGFloat
	var cornerRadius: CGFloat
	var foreground: Color
	var background: Color
	var animationDuration: CGFloat = 0.8
	/// View Properties
	@State private var nextValue: Int = 0
	@State private var currentValue: Int = 0
	@State private var rotation: CGFloat = 0
	var body: some View {
		let halfHeight = size.height * 0.5
		
		ZStack {
			UnevenRoundedRectangle(topLeadingRadius: cornerRadius, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: cornerRadius)
				.fill(background.shadow(.inner(radius: 1)))
				.frame(height: halfHeight)
				.overlay(alignment: .top) {
					TextView(nextValue)
						.frame(width: size.width, height: size.height)
						.drawingGroup()
				}
				.clipped()
				.frame(maxHeight: .infinity, alignment: .top)
			
			UnevenRoundedRectangle(topLeadingRadius: cornerRadius, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: cornerRadius)
				.fill(background.shadow(.inner(radius: 1)))
				.frame(height: halfHeight)
				.modifier(
					RotationModifier(
						rotation: rotation,
						currentValue: currentValue,
						nextValue: nextValue,
						fontSize: fontSize,
						foreground: foreground,
						size: size
					)
				)
				.clipped()
				.rotation3DEffect(
					.init(degrees: rotation),
					axis: (x: 1.0, y: 0.0, z: 0.0),
					anchor: .bottom,
					anchorZ: 0.01,
					perspective: 0.4
				)
				.frame(maxHeight: .infinity, alignment: .top)
				.zIndex(10)
			
			UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: cornerRadius, bottomTrailingRadius: cornerRadius, topTrailingRadius: 0)
				.fill(background.shadow(.inner(radius: 1)))
				.frame(height: halfHeight)
				.overlay(alignment: .bottom) {
					TextView(currentValue)
						.frame(width: size.width, height: size.height)
						.drawingGroup()
				}
				.clipped()
				.frame(maxHeight: .infinity, alignment: .bottom)
		}
		.frame(width: size.width, height: size.height)
		.onChange(of: value, initial: true) { oldValue, newValue in
			currentValue = oldValue
			nextValue = newValue
			
			guard rotation == 0 else {
				currentValue = newValue
				return
			}
			
			guard oldValue != newValue else { return }
			
			withAnimation(.easeInOut(duration: animationDuration), completionCriteria: .logicallyComplete) {
				rotation = -180
			} completion: {
				rotation = 0
				currentValue = value
			}
		}
	}
	
	/// Reusable View
	@ViewBuilder
	func TextView(_ value: Int) -> some View {
		Text("\(value)")
			.font(.system(size: fontSize).bold())
			.foregroundStyle(foreground)
			.lineLimit(1)
	}
}

fileprivate struct RotationModifier: ViewModifier, Animatable {
	var rotation: CGFloat
	var currentValue: Int
	var nextValue: Int
	var fontSize: CGFloat
	var foreground: Color
	var size: CGSize
	var animatableData: CGFloat {
		get { rotation }
		set { rotation = newValue }
	}
	
	func body(content: Content) -> some View {
		content
			.overlay(alignment: .top) {
				Group {
					if -rotation > 90 {
						Text("\(nextValue)")
							.font(.system(size: fontSize).bold())
							.foregroundStyle(foreground)
							.scaleEffect(x: 1, y: -1)
							.transition(.identity)
							.lineLimit(1)
					} else {
						Text("\(currentValue)")
							.font(.system(size: fontSize).bold())
							.foregroundStyle(foreground)
							.transition(.identity)
							.lineLimit(1)
					}
				}
				.frame(width: size.width, height: size.height)
				.drawingGroup()
			}
	}
}


struct FlipClockTextEffectMock: View {
	
	@State var hour:Int = 99
	@State var minute:Int = 99
	@State var second:Int = 99
	@State var year:Int = 2024
	@State var month:Int = 0
	@State var day:Int = 0
	@State var currentDate:Date = Date()
	var body: some View {
		
		VStack(alignment: .leading){
			Text(currentDate, format: Date.FormatStyle()
						  .year().month().day())
			.font(.title.bold())
			
			HStack{
				
				FlipClockTextEffect(
					value: $hour,
					size: CGSize(
						width: 100,
						height: 150
					),
					fontSize: 70,
					cornerRadius: 20,
					foreground: .black,
					background: .white
				)
				Text(":")
					.font(.largeTitle.bold())
				
				FlipClockTextEffect(
					value: $minute,
					size: CGSize(
						width: 100,
						height: 150
					),
					fontSize: 70,
					cornerRadius: 20,
					foreground: .black,
					background: .white
				)
				
				Text(":")
					.font(.largeTitle.bold())
				
				FlipClockTextEffect(
					value: $second,
					size: CGSize(
						width: 100,
						height: 150
					),
					fontSize: 70,
					cornerRadius: 20,
					foreground: .black,
					background: .white
				)
				
			}
		}
		
		
		.onReceive(Timer.publish(every: 1, on: .current, in: .common).autoconnect(), perform: { _ in
			let now = Date()
			self.currentDate = now
			let calendar = Calendar.current
			
			let components = calendar.dateComponents([.hour, .minute, .second, .year, .month, .day], from: now)
			
			
			if let year = components.year, let month = components.month, let day = components.day, let hour = components.hour, let minute = components.minute, let second = components.second {
				self.hour = hour
				self.minute = minute
				self.second = second
				self.year = year
				self.month = month
				self.day = day
			}
		})
	}
	
}


#Preview {
	FlipClockTextEffectMock()
}
