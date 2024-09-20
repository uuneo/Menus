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
    
    @State private var showCardDetail:Bool = false

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
        .onAppear{
            self.showCardDetail =  items.filter({$0.subcategoryId == subcategory.id}).allSatisfy { item in
               return  item.price1.money == 0 && item.price2.money == 0
            }
            
            
        }
    
        
        
    }
}


struct itemCardView: View {
    @StateObject var manager = peacock.shared
    
    var data:ItemData
    
    @Binding var show:Bool
    @State private var animate = false
    var colors:[Color] =  [.blue,.green,.teal,.cyan,.mint]
    
    var colors2:[Color] = [.red, .yellow, .orange, .pink]
    
    @State var size:CGSize = CGSize(width: 330, height: 160)
    @State  private var   showDetail:Bool = false
    
    let color1: Color
    let color2: Color
    
    init(data: ItemData, show: Binding<Bool>) {
        self.data = data
        self._show = show
        self.showDetail = show.wrappedValue
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
                .frame(width: size.width, height: size.height)
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
                    
                }.padding(.top, 10)
                    .padding(.leading, 10)
                    .padding(10)
                
                    .onTapGesture {
                        withAnimation(.spring()){
                            showDetail.toggle()
                        }
                    }
                
                
                if !isShow(show: showDetail, [data.price3.money,data.price4.money]) {
                    Spacer()
                }
                
                
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
                    .offset(y: showDetail ? 0 : -size.height)
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
                        .offset(y: showDetail ? 0 : size.height)
                        .opacity(Double(data.price4.money))
                    }
                    
                   
                    
                }
                
                .padding(.vertical,10)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.shadow1, radius:isShow(show: showDetail, [data.price3.money,data.price4.money]) ? 10 : 0, x: 10, y: 10)
                .shadow(color: Color.shadow2, radius: isShow(show: showDetail, [data.price3.money,data.price4.money]) ? 10 : 0, x: -10, y: -10)
                .opacity(isShow(show: showDetail, [data.price3.money,data.price4.money]) ? 1 : 0)
//                .offset(x: isShow(show: show, [data.price3.money,data.price4.money]) ? 0 : -size.width)
                .frame(height: isShow(show: showDetail, [data.price3.money,data.price4.money]) ? 60 : 0)
                
            
                
                
                
                HStack{
                    
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
                    .opacity(Double(data.price1.money))
                    Spacer()
                    
                    
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
                .padding(.vertical, 10)
                .padding(.horizontal)
                .opacity(Double(data.price2.money))
                .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 3, y: 3)
                
                
                
            }
            .frame(width: size.width , height: size.height)
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
                                .shadow(color: Color.shadow2, radius: 10, x: -10, y: -10)
                                .padding(.trailing)
                                .padding(.top, 10)
                        }
                        Spacer()
                    }
                }
               
               
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .clipped()
            .shadow(color: Color.shadow1, radius: 10, x: 10, y: 10)
            .shadow(color: Color.shadow2, radius: 10, x: -10, y: -10)
            
            
    }
    
    
        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.6), value: showDetail)
        .onChange(of: show) { oldValue, newValue in
            
            withAnimation {
                showDetail = newValue
            }
            
        }.onChange(of: showDetail) { oldValue, newValue in
            withAnimation {
                self.size =  CGSize(width: 330, height: isShow(show: showDetail, [data.price3.money,data.price4.money]) ? 230 : 160)
            }
            
        }
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

func isShow(show:Bool,_ numbers:[Int])->Bool{
    show && numbers.contains(where: {$0 != 0})
}


enum priceType {
    case price1,price2,price3,price4
}


#Preview {
    itemView()
}


