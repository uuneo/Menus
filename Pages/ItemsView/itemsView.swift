//
//  ItemDetailView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import SwiftUI
import ScalingHeaderScrollView
import Defaults

struct itemsView: View {
    @StateObject var manager = peacock.shared
    @Binding var show:Bool
    var detailName:Namespace.ID
    @State private var showList:Bool = true
    @State private var topLength:CGFloat = 0
    @State private var isScrolling:Bool = false
    @Namespace var ItemDataSpace
    
    @State private var showCardDetail:Bool = false
    
    var columns = Array(repeating: GridItem(.flexible(),spacing: 30), count: 3)
    
    @Default(.subcategoryItems) var subcategoryItems
    
    @Default(.items) var items
    
    var selectItems:[subcategoryData]{
       return subcategoryItems.filter({$0.categoryId  == manager.selectedItem.id})
    }
    
    var body: some View {
        
        ScalingHeaderScrollView {
            ZStack {
                Color(from: manager.selectedItem.color)
                    .edgesIgnoringSafeArea(.all)
                    .clipShape(RoundedRectangle(cornerRadius:  showList ? 0 : 100))
                    .matchedGeometryEffect(id: "\(manager.selectedItem.id)-background", in: detailName,properties: [.frame], isSource: show)
                
                
                
                largeHeader(progress: topLength)
                
                
            }
            .frame(width: UIScreen.main.bounds.width, height: 260)
        } content: {
            ZStack{
                
                VStack{
                    
                    ForEach(selectItems, id: \.id){item in
                        itemView(subcategory: item)
                    }
                }
            }
            .onChange(of: show) { oldValue, newValue in
                if newValue{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                            self.showList = true
                            self.isScrolling = true
                        }
                    }
                }else{
                    self.isScrolling = false
                }
                
            }
            
            
            
        }
        .initialSnapPosition(initialSnapPosition: 1)
        .allowsHeaderGrowth()
        .height(min: 100.0, max: 250.0)
        .collapseProgress( $topLength)
        .setHeaderSnapMode(.immediately)
        .hideScrollIndicators()
        .scrollToTop(resetScroll: $isScrolling)
        .background(
            Color.white
        )
        .ignoresSafeArea()
        .opacity(show ? 1 : 0)
        .offset(y: showList ? 0 : UIScreen.main.bounds.height)
  
        
        
        
    }
    
    private func largeHeader(progress: CGFloat) -> some View{
        ZStack{
            HStack{
                VStack{
                    Spacer()
                    Button{
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                            self.showList.toggle()
                            self.show.toggle()
                            manager.selectedItem = categoryData.example
                            
                        }
                        
                    }label:{
                        Image(systemName: "house.circle")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
                VStack(alignment: .leading){
                    Spacer()
                    
                    
                    Text(manager.selectedItem.title )
                        .font(.largeTitle)
                        .bold()
                        
                    
                    Text(manager.selectedItem.subTitle)
                    
                }
                .foregroundColor(.white)
                .frame(minWidth: 200)
                .padding(.vertical)
                .matchedGeometryEffect(id: "\(manager.selectedItem.id)-title", in: detailName,properties: [.position,.size,.frame], isSource: show)
                Spacer()
                
                VStack{
                    Spacer()
                    PickerOfCardView()
                    
                }
                
                
                
                VStack{
                    Spacer()
                    AsyncImageView(imageUrl: manager.selectedItem.image)
                    
                        .scaledToFit()
                        .frame(width: 200)
                        .padding(.trailing, 100)
                        .matchedGeometryEffect(id: "\(manager.selectedItem.id)-image", in: detailName,properties: [.position,.size,.frame], isSource: show)
                }
                
            }
            .opacity( 1 - progress)
            
            VStack{
                Spacer()
                HStack{
                    Button{
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                            self.showList.toggle()
                            
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                                self.show.toggle()
                                manager.selectedItem = categoryData.example
                            }
                        }
                        
                    }label:{
                        Image(systemName: "chevron.left.2")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    
                    Spacer()
                    
                    AsyncImageView(imageUrl: manager.selectedItem.image)
                        .scaledToFit()
                        .frame(width: 50)
                        .padding(.horizontal)
                    
                    Text(manager.selectedItem.title )
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    
                    
                    Text(manager.selectedItem.subTitle)
                        .lineLimit(1)
                        .foregroundColor(.white)
                    
                    PickerOfCardView()
                    
                    Spacer()
                    
                    
                    
                    
                    
                }
            }
            .opacity(progress)
            .opacity(max(0, min(1, (progress - 0.75) * 4.0)))
        
        }
       
    }
}


struct PickerOfCardView: View {
    @StateObject var manager = peacock.shared
    @Default(.cards) var cards
    let nonmember = VipCardData.nonmember
    var body: some View {
        Picker(selection: Binding(get: {
            manager.selectCard
        }, set: { value in
            manager.selectCard = value
        })) {
            Text("\(nonmember.title)\(nonmember.name)").tag(nonmember)
               
            ForEach(cards, id: \.id){card in
                Text("\(card.title)\(card.name)").tag(card)
                  
            }
        } label: {
            Text("选择卡片")
        }.padding()
            .accentColor(.white)
    }
}






#Preview {
    itemsView(show: .constant(true), detailName: Namespace().wrappedValue)
}
