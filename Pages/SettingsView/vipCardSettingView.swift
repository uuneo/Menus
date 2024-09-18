//
//  vipCardSettingView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/15.
//

import SwiftUI
import Defaults

struct vipCardSettingView: View {
   
    @Default(.Cards) var cards
    @State var showChange:Bool = false
    @Binding var columnVisibility: NavigationSplitViewVisibility
    var body: some View {
        List{
        
          
            ForEach($cards,id: \.id){card in
                NavigationLink{
                    changeVipCardView(card: card)
                }label: {
                    HStack{
                        
                        Label("\(card.title.wrappedValue)-\(card.name.wrappedValue)", systemImage: "pencil")
                        Spacer()
                        
                    }
                }
            }.onDelete(perform: { indexSet in
                cards.remove(atOffsets: indexSet)
            })
            .onMove(perform: { indices, newOffset in
                cards.move(fromOffsets: indices, toOffset: newOffset)
            })
        }
        .listStyle(.insetGrouped)
        .toolbar{
            
            
            ToolbarItem {
                Button{
                    cards.append(MemberCardData.space())
                }label: {
                    Image(systemName: "plus")
                }
            }
            
            
        }
    }
}



struct changeVipCardView: View {
    @Binding var card:MemberCardData
    @Environment(\.dismiss) var dismiss
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }
    
    var body: some View {
        Form{
            
            Section{
                TextField("标题", text: $card.title)
                    .customTitleField(icon: "pencil")
            }header: {
                Text("卡名称")
            }
            
            
            Section{
                TextField("副标题", text: $card.subTitle)
                    .customTitleField(icon: "pencil")
            }header: {
                Text("副标题")
            }
            
            
            Section{
                TextField("金额", value: $card.money, formatter: NumberFormatter())
                    .customTitleField(icon: "pencil")
            }header: {
                Text("金额")
            }
            
            Section{
                TextField("折扣名称", text: $card.name)
                    .customTitleField(icon: "pencil")
            }header: {
                Text("折扣名称")
            }
            Section{
                TextField("折扣", value: $card.discount, formatter: formatter)
                    .customTitleField(icon: "pencil")
                    .onChange(of: card.discount) { _ , newValue in
                        if newValue > 1{
                            card.discount = 1
                        }else if newValue < 0.1{
                            card.discount = 0
                        }
                    }
            }header: {
                Text("折扣")
            }
            
            
            
            Section{
                TextField("折扣2", value: $card.discount2, formatter: formatter)
                    .customTitleField(icon: "pencil")
                    .onChange(of: card.discount2) { _ , newValue in
                        if newValue > 1{
                            card.discount = 1
                        }else if newValue < 0{
                            card.discount = 0
                        }
                    }
            }header: {
                Text("折扣2")
            }
            
            
            Section{
                
                  TextField("图片", text: $card.image)
                      .customTitleField(icon: "pencil")
            }header: {
                Text("图片地址")
            }
            
            
            Section{
                TextEditor(text:  $card.footer)
                    .customTitleField(icon: "pencil")
            }header: {
                Text("中间文字")
            }
            
            
        }
        .scrollDismissesKeyboard(.immediately)
    }

}

#Preview {
    NavigationStack{
        vipCardSettingView(columnVisibility: .constant(.all))
    }
    
}
