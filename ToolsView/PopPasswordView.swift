//
//  PopPasswordView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/28.
//

import Foundation
import SwiftUI

/// Config
struct Config {
	var backgroundColor: Color = Color.primary.opacity(0.25)
	/// You can add extra properties here if you wish to.
}

/// It's a custom modifier
extension View {
	@ViewBuilder
	func popView<Content: View>(
		config: Config = .init(),
		isPresented: Binding<Bool>,
		onDismiss: @escaping () -> (),
		@ViewBuilder content: @escaping () -> Content
	) -> some View {
		self
			.modifier(
				PopViewHelper(
					config: config,
					isPresented: isPresented,
					onDismiss: onDismiss,
					viewContent: content
				)
			)
	}
}

fileprivate struct PopViewHelper<ViewContent: View>: ViewModifier {
	var config: Config
	@Binding var isPresented: Bool
	var onDismiss: () -> ()
	@ViewBuilder var viewContent: ViewContent
	/// Local View Properties
	@State private var presentFullScreenCover: Bool = false
	@State private var animateView: Bool = false
	func body(content: Content) -> some View {
		/// UnMutable Properties
		let screenHeight = screenSize.height
		let animateView = animateView
		
		content
			.fullScreenCover(isPresented: $presentFullScreenCover, onDismiss: onDismiss) {
				ZStack {
					Rectangle()
						.fill(config.backgroundColor)
						.ignoresSafeArea()
						.opacity(animateView ? 1 : 0)
					
					viewContent
						.visualEffect({ content, proxy in
							content
								.offset(y: offset(proxy, screenHeight: screenHeight, animateView: animateView))
						})
						.presentationBackground(.clear)
						.task {
							guard !animateView else { return }
							withAnimation(.bouncy(duration: 0.4, extraBounce: 0.05)) {
								self.animateView = true
							}
						}
						.ignoresSafeArea(.container, edges: .all)
				}
			}
			.onChange(of: isPresented) { oldValue, newValue in
				if newValue {
					toggleView(true)
				} else {
					Task {
						withAnimation(.snappy(duration: 0.45, extraBounce: 0)) {
							self.animateView = false
						}
						
						try? await Task.sleep(for: .seconds(0.45))
						
						toggleView(false)
					}
					
					/// Or You can use the default SwiftUI Animation Completion Modifier
//                    withAnimation(.snappy(duration: 0.45, extraBounce: 0), completionCriteria: .logicallyComplete) {
//                        self.animateView = false
//                    } completion: {
//                        toggleView(false)
//                    }
				}
			}
	}
	
	func toggleView(_ status: Bool) {
		var transaction = Transaction()
		transaction.disablesAnimations = true
		
		withTransaction(transaction) {
			presentFullScreenCover = status
		}
	}
	
	nonisolated func offset(_ proxy: GeometryProxy, screenHeight: CGFloat, animateView: Bool) -> CGFloat {
		let viewHeight = proxy.size.height
		return animateView ? 0 : (screenHeight + viewHeight) / 2
	}
	
	var screenSize: CGSize {
		if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
			return screenSize
		}
		
		return .zero
	}
}



struct CustomAlertWithTextField: View {
	@Binding var show: Bool
	var onUnlock: (String) -> ()
	/// View Properties
	@State private var password: String = ""
	var body: some View {
		VStack(spacing: 8) {
			Image(systemName: "person.badge.key.fill")
				.font(.title)
				.foregroundStyle(.white)
				.frame(width: 65, height: 65)
				.background {
					Circle()
						.fill(.blue.gradient)
						.background {
							Circle()
								.fill(Color.background)
								.padding(-5)
						}
				}
			
			Text("Locked File")
				.fontWeight(.semibold)
			
			Text("This file has been locked by the user, please enter the password to continue.")
				.multilineTextAlignment(.center)
				.font(.caption)
				.foregroundStyle(.gray)
				.padding(.top, 5)
			
			SecureField("Password", text: $password)
				.padding(.vertical, 10)
				.padding(.horizontal, 15)
				.background {
					RoundedRectangle(cornerRadius: 12)
						.fill(.bar)
				}
				.padding(.vertical, 10)
			
			HStack(spacing: 10) {
				Button {
					show = false
					onUnlock("canceAndCloselView")
				} label: {
					Text("Cancel")
						.foregroundStyle(.white)
						.fontWeight(.semibold)
						.padding(.vertical, 8)
						.padding(.horizontal, 25)
						.background {
							RoundedRectangle(cornerRadius: 12)
								.fill(.red.gradient)
						}
				}

				Button {
					show = false
					onUnlock(password)
				} label: {
					Text("Unlock")
						.foregroundStyle(.white)
						.fontWeight(.semibold)
						.padding(.vertical, 8)
						.padding(.horizontal, 25)
						.background {
							RoundedRectangle(cornerRadius: 12)
								.fill(.blue.gradient)
						}
				}
			}
		}
		.frame(width: 250)
		.padding([.horizontal, .bottom], 20)
		.background {
			RoundedRectangle(cornerRadius: 25)
				.fill(Color.background)
				.padding(.top, 25)
		}
	}
}

struct CustomAlert: View {
	@Binding var show: Bool
	var onTryAgain: (Bool) -> ()
	var body: some View {
		VStack(spacing: 8) {
			Image(systemName: "lock.trianglebadge.exclamationmark.fill")
				.font(.title)
				.foregroundStyle(.white)
				.frame(width: 65, height: 65)
				.background {
					Circle()
						.fill(.red.gradient)
						.background {
							Circle()
								.fill(Color.background)
								.padding(-5)
						}
				}
			
			Text("Wrong Password")
				.fontWeight(.semibold)
			
			Text("Please enter the correct password to unclock the file.")
				.multilineTextAlignment(.center)
				.font(.caption)
				.foregroundStyle(.gray)
				.padding(.top, 5)
			
			HStack(spacing: 10) {
				Button {
					show = false
					onTryAgain(false)
				} label: {
					Text("Cancel")
						.foregroundStyle(.white)
						.fontWeight(.semibold)
						.padding(.vertical, 8)
						.padding(.horizontal, 25)
						.background {
							RoundedRectangle(cornerRadius: 12)
								.fill(.red.gradient)
						}
				}

				Button {
					show = false
					onTryAgain(true)
				} label: {
					Text("Try Again")
						.foregroundStyle(.white)
						.fontWeight(.semibold)
						.padding(.vertical, 8)
						.padding(.horizontal, 25)
						.background {
							RoundedRectangle(cornerRadius: 12)
								.fill(.blue.gradient)
						}
				}
			}
			.padding(.top, 10)
		}
		.frame(width: 250)
		.padding([.horizontal, .bottom], 20)
		.background {
			RoundedRectangle(cornerRadius: 25)
				.fill(Color.background)
				.padding(.top, 25)
		}
	}
}
