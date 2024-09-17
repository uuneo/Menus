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
    var subcategory:subcategoryData = subcategoryData.example
    @Default(.items) var items
    
    @State private var showCardDetail:Bool = false
    var body: some View {
        ZStack{
            
            VStack(alignment: .leading){
                
                HStack{
                    VStack(alignment: .leading){
                        
                        Text(subcategory.title)
                            .font(.title)
                            .bold()
                            .padding(.top)
                        Text(subcategory.subTitle)
                    }.padding(.horizontal, 50)
                    Spacer()
                    
                    HStack{
                        Text(subcategory.footer)
                    }
                    
                    HStack{
                        Toggle(isOn: $showCardDetail){
                            Label("显示课程", systemImage: "list.bullet.rectangle")
                        }
                        Spacer()
                    }
                    
                    .frame(maxWidth: 200)
                    .padding(.horizontal, 10)
                    
                }
                ScrollView(.horizontal, showsIndicators: false){
                    LazyHStack{
                        ForEach(items.filter({$0.subcategoryId == subcategory.id}),id: \.id){ item in
                            itemCardView(data: item, show: $showCardDetail)
                                .padding()
                            
                        }
                    }.padding(.horizontal, 30)
                    
                }
            }
            
            
        }
        
        
    }
}


struct itemCardView: View {
    @StateObject var manager = peacock.shared
    
    var data:itemData
    
    @Binding var show:Bool
    @State private var animate = false
    var colors:[Color] =  [.blue,.green,.teal,.cyan,.mint]
    
    var colors2:[Color] = [.red, .yellow, .orange, .pink]
    
    @State var size:CGSize = CGSize(width: 300, height: 150)
    
    
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
            
            
            ZStack{
                colors.randomElement()
                    .clipShape(Circle())
                    .frame(width: 80, height: 80)
                    .offset(y: animate ? -20 : 20)
                    .offset(x: animate ? -150 : 150)
                    .rotationEffect(.degrees(animate ? 0 : 365),anchor: .bottomLeading)
                    .blendMode(.hardLight)
                
                colors2.randomElement()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .offset(y: animate ? -100 : 100)
                    .offset(x: animate ? -100 : 100)
                    .rotationEffect(.degrees(animate ? 0 : -365),anchor: .bottomLeading)
                    .blendMode(.hardLight)
                    .onAppear{
                        withAnimation(.linear(duration: 30).repeatForever(autoreverses: true)){
                            animate.toggle()
                        }
                    }
            }
            .frame(width: size.width , height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .clipped()
            
            
            
            VStack{
                
                HStack{
                    VStack(alignment: .leading){
                        Text(data.title)
                            .font(.title)
                            .bold()
                            .minimumScaleFactor(0.5)
                        Text(data.subTitle)
                            .minimumScaleFactor(0.5)
                    }
                    
                    .foregroundStyle(.black)
                    Spacer()
                }.padding(.top, 10)
                    .padding(.leading, 10)
                    .padding(10)
                
                    .onTapGesture {
                        withAnimation(.spring()){
                            show.toggle()
                            
                        }
                    }
                
                
                if !isShow(show: show, [data.price3.money,data.price4.money]) {
                    Spacer()
                }
                
                
                HStack{
                    
                    HStack{
                        Spacer()
                        Text(data.price3.prefix)
                            .foregroundStyle(.black)
                            .font(.system(size: 18))
                            .bold()
                            .minimumScaleFactor(0.6)
                        
                        
                        Text(String(format: "%.0f", price3))
                            .bold()
                            .font(.system(size: 25))
                            .minimumScaleFactor(0.6)
                            .animation(.spring(duration: 0.5, bounce: 0.5, blendDuration: 0.6), value: price3)
                        
                        
                        
                        Text(data.price3.suffix)
                            .foregroundStyle(.black)
                            .font(.system(size: 18))
                            .bold()
                            .minimumScaleFactor(0.6)
                        Spacer()
                    }
                .offset(y: show ? 0 : -size.height)
                .opacity(Double(data.price3.money))
                Divider()
                    .background(.white)
                HStack{
                    Spacer()
                    
                    Text(data.price4.prefix)
                        .foregroundStyle(.black)
                        .font(.system(size: 18))
                        .bold()
                        .minimumScaleFactor(0.6)
                    Text(String(format: "%.0f", price4))
                        .font(.system(size: 25))
                        .minimumScaleFactor(0.6)
                        .animation(.spring(duration: 0.5, bounce: 0.5, blendDuration: 0.6), value: price4)
                    Text(data.price4.suffix)
                        .foregroundStyle(.black)
                        .font(.system(size: 18))
                        .bold()
                        .minimumScaleFactor(0.6)
                    Spacer()
                }
                .offset(y: show ? 0 : size.height)
                .opacity(Double(data.price4.money))
                
            }
            .foregroundStyle(.white)
            .padding(.vertical,10)
            .background(.pink.gradient)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(isShow(show: show, [data.price3.money,data.price4.money]) ? 1 : 0)
            .offset(x: isShow(show: show, [data.price3.money,data.price4.money]) ? 0 : -size.width)
            .frame(height: isShow(show: show, [data.price3.money,data.price4.money]) ? 50 : 0)
            
            
            
            
            
            
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
                        .animation(.spring(duration: 0.5, bounce: 0.5, blendDuration: 0.6), value: price1)
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
                    .animation(.spring(duration: 0.5, bounce: 0.5, blendDuration: 0.6), value:  price2)
                
                
                
                
                Text(data.price2.suffix)
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
                    .minimumScaleFactor(0.6)
            }
            .foregroundStyle(.black)
            .padding(.vertical, 10)
            .padding(.horizontal)
            .opacity(Double(data.price2.money))
            
            
            
            
        }
        
        .frame(width: size.width , height: size.height)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .clipped()
        .shadow(radius: 10.0)
        
        
    }
    
    
        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.6), value: show)
        .onChange(of: show) { oldValue, newValue in
            withAnimation {
                self.size =  CGSize(width: 300, height: isShow(show: show, [data.price3.money,data.price4.money]) ? 200 : 150)
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
