//
//  VipCardView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/9.
//

import SwiftUI

struct VipCardView:View {
    @Binding var item:VipCardData
    var size:CGSize = CGSize(width: 340, height: 220)
    @Binding var show:Bool
    var body: some View {
        
        ZStack {
            
            VStack{
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color("accent"))
                            .padding(.top)
                        
                        Text(item.subTitle)
                            .font(.caption.bold())
                            .foregroundColor(.white)
                        
                        
                    }
                    Spacer()
                    
                    Text(item.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("accent"))
                }
                .padding(.horizontal)
                Spacer()
            }
            
            
            
            
            VStack{
                Spacer()
                HStack(alignment: .bottom){
                    HStack{
                        Text("¥")
                            .font(.caption)
                        
                        Text("\(item.money)")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        
                        
                        Text("元")
                            .font(.caption)
                        
                    }.padding()
                        .foregroundColor(Color("accent"))
                    Spacer()
                    
                }
            }
            
            
            VStack{
                Spacer()
                
                HStack{
                    Spacer()
                    AsyncImageView(imageUrl: item.image)
                        .scaledToFit()
                        .frame(width:size.width / 2)
                }
                
                
            }
            
            HStack{
                Text(item.footer)
                    .font(.system(size: 17))
                    .lineLimit(3)
                    .bold()
                    .foregroundColor(.white)
                    .offset(x: show ? 0 : -size.width)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(10)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(x: show ? 0 : -size.width + 10)
           
            
        }
        .frame(width: size.width, height: size.height)
        .background(Color.black)
        .clipped()
        .cornerRadius(10)
        .shadow(radius: 10)
        .onTapGesture {
            withAnimation(.spring(duration: 0.6, bounce: 0.5, blendDuration: 0.5)) {
                self.show.toggle()
            }
           
        }
        .padding()
    }


}


#Preview {
    VipCardView(item: .constant(VipCardData.example), show: .constant(true))
}
