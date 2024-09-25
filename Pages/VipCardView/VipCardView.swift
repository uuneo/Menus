//
//  VipCardView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/9.
//

import SwiftUI

struct VipCardView:View {
    @Binding var item:MemberCardData
    var size:CGSize = CGSize(width: 340, height: 220)
    @Binding var show:Bool
    
    var body: some View {
        
        ZStack {
            
            VStack{
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("accent2"))
                            .padding(.top)
                            .minimumScaleFactor(0.5)
                        
                        Text(item.subTitle)
                            .font(.caption.bold())
                            .foregroundColor(.white)
                        
                        
                    }
                    Spacer()
                
                    Text(item.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("accent2"))
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
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        
                        
                        Text("元")
                            .font(.caption)
                        
                    }.padding()
                        .foregroundColor(Color("accent2"))
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
			.contentShape(RoundedRectangle(cornerRadius: 10))
			.onTapGesture {
				withAnimation(.spring(duration: 0.6, bounce: 0.5, blendDuration: 0.5)) {
					self.show.toggle()
				}
			   
			}
			
			
           
            
        }
        .frame(width: size.width, height: size.height)
        .background(Color.background0)
        .clipped()
        .cornerRadius(10)
		.shadow(color: Color.backgroundShadow, radius: 10, x: 5, y: 10)
		.shadow(color: Color.shadow2, radius: 1, x: -1, y: -1)
        
       
    }


}


#Preview {
    VipCardView(item: .constant(MemberCardData.space()), show: .constant(true))
}
