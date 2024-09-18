//
//  ItemsIphoneView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/17.
//

import SwiftUI
import ScalingHeaderScrollView
import Defaults

struct ItemsIphoneView: View {
    @StateObject var manager = peacock.shared
    @Binding var show:Bool
    var detailName:Namespace.ID
    
    @State private var showList:Bool = true
    @State private var topLength:CGFloat = 0
    @State private var isScrolling:Bool = false
    
    @Default(.subcategoryItems) var subcategoryItems
    @Default(.items) var items
    
    var selectItems:[subcategoryData]{
       return subcategoryItems.filter({$0.categoryId  == manager.selectedItem.id})
    }
    
    @State private var offset: CGSize = .zero
    var body: some View {
        ZStack{
            ScalingHeaderScrollView {
                ZStack {
                    Color(from: manager.selectedItem.color)
                        .edgesIgnoringSafeArea(.all)
                        .matchedGeometryEffect(id: "\(manager.selectedItem.id)-background", in: detailName,properties: [.frame], isSource: show)

                   
                    
                    largeHeader(progress: topLength)
                   
                }
            }content: {
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
        } 
        .offset(x: offset.width,y: offset.height)
      
       
        
    }
    
    private func  largeHeader(progress: CGFloat) -> some View{
        
        ZStack{
            ZStack{
                VStack{
                    Spacer()
                    HStack(alignment: .bottom){
                        Button{
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                                self.showList.toggle()
                                self.show.toggle()
                                manager.selectedItem = categoryData.example
                                
                            }
                            
                        }label:{
                            Image(systemName: "chevron.left.2")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading){
                            
                            
                            Text(manager.selectedItem.title )
                                .font(.title)
                                .bold()
                                .minimumScaleFactor(0.5)
                            
                            Text(manager.selectedItem.subTitle)
                                .minimumScaleFactor(0.5)
                            
                        }
                        .foregroundColor(.white)
                        .matchedGeometryEffect(id: "\(manager.selectedItem.id)-title", in: detailName,properties: [.position,.size,.frame], isSource: show)
                        
                        
                       
                        Spacer()
                    }
                }
                
                VStack{
                    HStack{
                        Spacer()
                         PickerOfCardView()
                            .padding(.top, 30)
                    }
                    Spacer()
                }
                
                
              
                
                HStack{
                    Spacer()
                    VStack{
                        Spacer()
                        AsyncImageView(imageUrl: manager.selectedItem.image)
                        
                            .scaledToFit()
                            .frame(width: 100)
                            .padding(.trailing, 10)
                            .matchedGeometryEffect(id: "\(manager.selectedItem.id)-image", in: detailName,properties: [.position,.size,.frame], isSource: show)
                    }
                }
            }
            .padding(10)
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
                    }
                    
                    
                    VStack(alignment: .leading){
                        
                        Text(manager.selectedItem.title )
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        
                        Text(manager.selectedItem.subTitle)
                            .lineLimit(1)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.5)
                    }
                    Spacer()
                    
                    PickerOfCardView()
                        
                        
                }.padding(.horizontal,10)
            }
            .opacity(progress)
            .opacity(max(0, min(1, (progress - 0.75) * 4.0)))
        
        }
    }
}

#Preview {
    ItemsIphoneView(show: .constant(true),detailName:  Namespace().wrappedValue)
}
