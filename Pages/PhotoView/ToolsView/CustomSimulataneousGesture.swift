//
//  CustomSimulataneousGesture.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/29.
//


import SwiftUI

struct CustomSimulataneousGesture: UIViewRepresentable {
	@Binding var isAdded: Bool
	var handle: (UIPanGestureRecognizer) -> ()
	
	func makeCoordinator() -> Coordinator {
		Coordinator(handle: handle)
	}
	
	func makeUIView(context: Context) -> UIView {
		let view = UIView(frame: .zero)
		view.backgroundColor = .clear
		
		if !isAdded {
			DispatchQueue.main.async {
				if let scrollView = view.superview?.superview?.superview as? UIScrollView, !(scrollView.gestureRecognizers ?? []).contains(where: { $0.name == "ScrollInteractionGesture" }) {
					let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.gestureHandle(gesture:)))
					gesture.delegate = context.coordinator
					gesture.name = "ScrollInteractionGesture"
					scrollView.addGestureRecognizer(gesture)
					isAdded = true
				}
			}
		}
		
		return view
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {  }
	
	class Coordinator: NSObject, UIGestureRecognizerDelegate {
		var handle: (UIPanGestureRecognizer) -> ()
		init(handle: @escaping (UIPanGestureRecognizer) -> Void) {
			self.handle = handle
		}
		
		@objc
		func gestureHandle(gesture: UIPanGestureRecognizer) {
			handle(gesture)
		}
		
		func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			return true
		}
	}
}
