//
//  HomeItemsView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//


import Defaults
import SwiftUI

struct HomeItemsView: View {
    
    @State var showContent = false
    @State var showMenu = false
   
    var NewHomeName:Namespace.ID
    @Binding var showDetail:Bool
    
    @Default(.categoryItems) var items
    @Default(.homeItemsTitle) var title
    @Default(.homeItemsSubTitle) var subTitle
    
    var body: some View {
  
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.title)
                            .fontWeight(.heavy)

                        Text(subTitle)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                   
                }
                .padding(.leading, 30.0)
              
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30.0) {
                        ForEach($items) { item in
                            Button(action: {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)){
                                    peacock.shared.selectedItem = item.wrappedValue
                                    self.showDetail.toggle()
                                }
                               
                            }) {
                                categoryCardView(item: item, NewHomeName: NewHomeName, show: showDetail)
                                
                            }
                        }
                    }
                    .padding(.trailing, 100)
                    .padding(.leading, 30)
                    .padding(.top)
                }
                
            }
            
            
    
       
    }
}

struct categoryCardView: View {
    @Binding var item: categoryData
    var NewHomeName:Namespace.ID
    var show:Bool
    
    var body: some View {
        ZStack{
            Color(from:  item.color)
                .matchedGeometryEffect(id: "\(item.id)-background", in: NewHomeName,properties: [.frame], isSource: !show)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading){
                    Text(item.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                        .lineLimit(4)
                    Text(item.subTitle)
                    
                    
                }
                .foregroundColor(.white)
                .padding(30)
                .matchedGeometryEffect(id: "\(item.id)-title", in: NewHomeName,properties: [.position,.size,.frame], isSource: !show)
                
                Spacer()
                
               
                
                AsyncImageView(imageUrl: item.image)
                    
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 246, height: 170)
                    .matchedGeometryEffect(id: "\(item.id)-image", in: NewHomeName,properties: [.position,.size,.frame], isSource: !show)
            }
           
        }
        .cornerRadius(30)
        .shadow(color: Color(from: item.color).opacity(0.5), radius: 20, x: 0, y: 20)
        .padding()
        .padding(.bottom)
        
        
        
    }
}

#Preview {
    HomeItemsView(NewHomeName: Namespace().wrappedValue, showDetail: .constant(false))
}
