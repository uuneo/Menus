//
//  itemView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/14.
//

import SwiftUI
import Defaults
import Pow

struct itemView: View {
	var subcategory:SubCategoryData = SubCategoryData.example
	@Default(.Items) var items
	
	@State private var showCardDetail:Bool = true
	
	var body: some View {
		ZStack{
			
			VStack(alignment: .leading){
				
				HStack{
					
					ZStack(alignment: .bottomTrailing) {
						VStack(alignment: .leading){
							
							Text(subcategory.title)
								.font( ISPAD ?.title :.title2)
								.bold()
								.padding(.top)
								.lineLimit(1)
								.layoutPriority(1)
								.fixedSize(horizontal: true, vertical: false)
							
							Text(subcategory.subTitle)
								.font( .title3)
								.foregroundStyle(Color.gray)
								.minimumScaleFactor(0.8)
								.lineLimit(1)
								.fixedSize(horizontal: true, vertical: false)
							
							
							if !ISPAD{
								Text(subcategory.footer)
									.minimumScaleFactor(0.3)
									.lineLimit(1)
								
							}
							
							
						}
						
						Text("\(items.filter({$0.subcategoryId == subcategory.id}).count)")
							.padding(5)
							.foregroundStyle(.gray)
							.offset(x: 20)
						
						
					}
					
					.padding(.leading, ISPAD ? 50 : 30)
					
					
					if ISPAD{
						Text(subcategory.footer)
							.padding(.leading, 10)
							.minimumScaleFactor(0.3)
							.lineLimit(1)
							.padding(.leading)
					}
					
					
					
					
					
					Spacer()
					
					HStack{
						
						Toggle(isOn: $showCardDetail){
							
							if ISPAD{
								Label("显示课程", systemImage: "list.bullet.rectangle")
									.minimumScaleFactor(0.3)
							}
							
						}
						
						
						Spacer()
					}
					.frame(maxWidth: ISPAD ? 200 : 40)
					.padding(.trailing, 10)
					
				}
				ScrollView(.horizontal, showsIndicators: false){
					HStack{
						ForEach(items.filter({$0.subcategoryId == subcategory.id}),id: \.id){ item in
							itemCardView(data: item, show: $showCardDetail)
								.padding()
								.padding(.bottom)
							
							
						}
					}.padding(.horizontal, 30)
					
				}
				
			}
			
			
		}
		
		
		
	}
}

enum showType{
	case all
	case base
	case course
}



struct itemCardView: View {
	@EnvironmentObject var manager:peacock
	
	var data:ItemData
	
	@Binding var show:Bool
	@State private var animate = false
	
	
	
	let color1: Color
	let color2: Color
	
	init(data: ItemData, show: Binding<Bool>) {
		self.data = data
		self._show = show
		// 只在初始化时生成随机颜色
		self.color1 = [.blue, .green, .teal, .cyan, .mint].randomElement() ?? .blue
		self.color2 = [.red, .yellow, .orange, .pink].randomElement() ?? .red
	}
	
	
	var price1:Double{
		priceHandler(item: data.price1, mode: .price1)
	}
	
	var price2:Double{
		priceHandler(item: data.price2, mode: .price2)
	}
	
	var price3:Double{
		priceHandler(item: data.price3, mode: .price3)
	}
	
	var price4:Double{
		priceHandler(item: data.price4, mode: .price4)
	}
	

	@State private var textColor:Color = .black
	
	
	var numberFormatter: NumberFormatter {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		numberFormatter.locale = .current
		numberFormatter.maximumFractionDigits = 1
		return numberFormatter
	}
	
	
	
	var showType:showType{
		let one = price1 != 0 || price2 != 0
		let two = price3 != 0 || price4 != 0
		if one && two {
			return .all
		}else if one && !two{
			return .base
		}else{
			return .course
		}
	}
	
	@State private var width:CGFloat = 330
	
	var height: CGFloat {
		showType == .all ? (show  ? 220 : 160) : 160
	}
	
	var body: some View {
		ZStack{
			
			TimelineView(.animation) { timeline in
				let time = timeline.date.timeIntervalSinceReferenceDate
				let progress = sin(time * .pi / 50) // 使用 sin() 函数来平滑动画
				
				ZStack {
					// 第一个圆的动画
					color1
						.clipShape(Circle())
						.frame(width: 80, height: 80)
						.offset(y: progress * 20) // 使用 sin() 函数来平滑变化
						.offset(x: progress * 150)
						.rotationEffect(.degrees(progress * 365), anchor: .bottomLeading)
						.blendMode(.hardLight)
					
					// 第二个圆的动画
					color2
						.clipShape(Circle())
						.frame(width: 50, height: 50)
						.offset(y: -progress * 100)
						.offset(x: -progress * 100)
						.rotationEffect(.degrees(-progress * 365), anchor: .bottomLeading)
						.blendMode(.hardLight)
				}
				.clipShape(RoundedRectangle(cornerRadius: 30))
			}
			
			VStack{
				
				HStack{
					VStack(alignment: .leading){
						Text(data.title)
							.font( ISPAD ?.title :.title2)
							.bold()
						
						Text(data.subTitle)
							.font(.callout)
							.foregroundStyle(Color.gray)
						
					}
					.foregroundStyle(Color.accent1)
					Spacer()
					
				}
				.padding(.top, 10)
				.padding(.leading, 10)
				.padding(10)
				.onTapGesture {
					debugPrint(show)
					self.show.toggle()
				}
				
				if showType != .all {
					Spacer()
				}
				
				if (show && showType == .all) || showType == .course{
					HStack{
						
						HStack{
							Spacer()
							Text(data.price3.prefix)
								.foregroundStyle(.gray)
								.font(.system(size: 15))
								.bold()
								.minimumScaleFactor(0.6)
							
							
							Text(String(format: "%.0f", price3))
								.bold()
								.font(.system(size: 25))
								.minimumScaleFactor(0.6)
							
								.foregroundStyle(color2)
							
							
							Text(data.price3.suffix)
								.foregroundStyle(.gray)
								.font(.system(size: 15))
								.bold()
								.minimumScaleFactor(0.6)
							Spacer()
						}
						.opacity(Double(data.price3.money))
						
						if data.price4.money != 0{
							Divider()
								.background(Color.background)
							
							HStack{
								Spacer()
								
								Text(data.price4.prefix)
									.foregroundStyle(.gray)
									.font(.system(size: 15))
									.bold()
									.minimumScaleFactor(0.6)
								Text(String(format: "%.0f", price4))
									.bold()
									.font(.system(size: 25))
									.minimumScaleFactor(0.6)
								
									.foregroundStyle(color1)
								Text(data.price4.suffix)
									.foregroundStyle(.gray)
									.font(.system(size: 15))
									.bold()
									.minimumScaleFactor(0.6)
								Spacer()
							}
						}
						
						
						
					}
					
					.padding(.vertical,10)
					.background(.ultraThinMaterial)
					.clipShape(RoundedRectangle(cornerRadius: 10))
					.shadow(color: Color.shadow1, radius: 10, x: 10, y: 10)
					.shadow(color: Color.shadow2, radius: 1, x: -1, y: -1)
					.frame(height: 60)
					.transition(.scale)
				}
				
				
				if showType == .base || showType == .all {
					HStack{
						
						if data.price1.money != 0{
							HStack{
								Text(data.price1.prefix)
									.font(.system(size: 15))
									.foregroundStyle(.gray)
									.minimumScaleFactor(0.6)
								Text(String(format: "%.0f", price1))
									.bold()
									.font(.system(size: 25))
									.minimumScaleFactor(0.6)
								Text(data.price1.suffix)
									.font(.system(size: 15))
									.foregroundStyle(.gray)
									.minimumScaleFactor(0.6)
							}
						}
						
						Spacer()
						
						if  data.price2.money != 0{
							HStack{
								Text(data.price2.prefix)
									.font(.system(size: 15))
									.foregroundStyle(.gray)
									.minimumScaleFactor(0.6)
								Text(String(format: "%.0f",  price2))
									.bold()
									.font(.system(size: 25))
									.minimumScaleFactor(0.6)
									.foregroundStyle(Color.cyan)
								
								Text(data.price2.suffix)
									.font(.system(size: 15))
									.foregroundStyle(.gray)
									.minimumScaleFactor(0.6)
							}
							
						}
						
					}
					.padding(.vertical, 10)
					.padding(.horizontal)
					.shadow(color: Color.gray.opacity(0.3), radius: 3, x: 3, y: 3)
				}
				
				
				
				
				
			}
			.frame(width: width , height: height)
			.background(.ultraThinMaterial)
			
			.overlay{
				if data.header  != ""{
					VStack{
						HStack{
							Spacer()
							Text(data.header)
								.padding(5)
								.background(.ultraThinMaterial)
								.foregroundStyle(Color.gray)
								.clipShape(Capsule())
								.shadow(color: Color.shadow1, radius: 10, x: 10, y: 10)
								.shadow(color: Color.shadow2, radius: 1, x: -1, y: -1)
								.padding(.trailing)
								.padding(.top, 10)
						}
						Spacer()
					}
				}
				
			}
			
			
			
			
		}
		
		.frame(width: width, height: height)
		.clipShape(RoundedRectangle(cornerRadius: 30))
		.clipped()
		.shadow(color: Color.shadow1, radius: 10, x: 10, y: 10)
		.shadow(color: Color.shadow2, radius: 1, x: -1, y: -1)
		.animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.6), value: show)
	
	}
	
	func priceHandler(item:PriceData,mode:priceType)-> Double{
		let select =  manager.selectCard
		
		
		if item.discount{
			switch mode {
			case .price1:
				return Double(item.money) *  select.discount
			case .price2:
				return Double(item.money) *  select.discount
			case .price3:
				return Double(item.money) *  select.discount2
			case .price4:
				return Double(item.money) *  select.discount2
			}
		}else{
			return Double(item.money)
		}
		
		
	}
	
	
	
}




enum priceType {
	case price1,price2,price3,price4
}


#Preview{
	@Previewable @State var show:Bool = true
	itemCardView(data: ItemData( categoryId: "", subcategoryId: "", title: "示例项目", subTitle: "123", header: "",
								 price1: PriceData( prefix: "", money: 1000, suffix: "", discount: false),
								 price2: PriceData( prefix: "", money: 1000, suffix: "", discount: false),
								 price3: PriceData( prefix: "", money: 1000, suffix: "", discount: false),
								 price4: PriceData( prefix: "", money: 0, suffix: "", discount: false)),
				 show: $show)
	.environmentObject(peacock.shared)
}


