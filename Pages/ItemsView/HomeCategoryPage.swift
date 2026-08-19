//
//  HomeCategoryPage.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import Defaults
import RealmSwift
import SwiftUI

struct HomeCategoryPage: View {
    @State var showContent = false
    @State var showMenu = false

    @ObservedResults(CategoryRealmData.self, sortDescriptor: SortDescriptor(
        keyPath: \CategoryRealmData.sort, ascending: true
    )) var items
    
    @ObservedResults(MenusHomeInfo.self) var homeInfos

   @State private var manager = peacock.shared

    @Namespace private var itemSpace

    @State private var selectedItem: CategoryRealmData? = nil

    var body: some View {
       
        VStack {
            HStack {
                if let homeInfo = homeInfos.first{
                    VStack(alignment: .leading) {
                        Text(homeInfo.homeItemsTitle)
                            .font(.title)
                            .fontWeight(.heavy)

                        Text(homeInfo.homeItemsSubTitle)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            .padding(.leading, 30.0)

            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        scallBtn(proxy: proxy, isHead: true)

                        ForEach(items, id: \.id) { item in
                            Button(action: {
                                withAnimation(.spring(
                                    response: 0.5,
                                    dampingFraction: 0.8,
                                    blendDuration: 0.8
                                )) {
                                    self.selectedItem = item
                                    proxy.scrollTo(item.id, anchor: .center)
                                }
                            }) {
                                if ISPAD {
                                    categoryCardView(item: item)
                                        .fixedSize(horizontal: true, vertical: false)
                                        .zIndex(100)
                                } else {
                                    GeometryReader { geometry in
                                        HStack {
                                            categoryCardView(item: item)
                                                .fixedSize(horizontal: true, vertical: false)
                                        }
                                        .rotation3DEffect(
                                            Angle(degrees: Double(geometry.frame(in: .global)
                                                    .minX - 40) / -20),
                                            axis: (x: 0, y: 10, z: 0)
                                        )
                                    }.frame(width: 260)
                                }
                            }
                            .padding(.trailing, 30)
                            .id(item.id)
                            .matchedTransitionSource(id: item.id, in: itemSpace)
                        }

                        scallBtn(proxy: proxy)
                    }
                    .padding(.trailing, 30)
                    .padding(.leading, 10)
                }
            }
        }
        .fullScreenCover(item: $selectedItem) { item in
            CategoryDetailPage(selectedItem: item)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
                .navigationTransition(
                    .zoom(sourceID: item.id, in: itemSpace)
                )
        }
    }
}

struct categoryCardView: View {
    @ObservedRealmObject var item: CategoryRealmData
    //	@Binding var item: CategoryData
   @State private var manager = peacock.shared
    var body: some View {
        ZStack {
            Color(from: item.color)

            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)

                    Text(item.subTitle)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .foregroundColor(.white)
                .padding(30)

                Spacer()

                AsyncImageView(imageURL: item.image)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 260)
            }
        }

        .cornerRadius(30)
        .shadow(color: Color.shadow2, radius: 1, x: -1, y: -1)
        .shadow(color: Color.shadow1, radius: 1, x: 1, y: 1)
        .shadow(color: Color.shadow1, radius: 10, x: 10, y: 10)
        .shadow(color: Color(from: item.color), radius: 3, x: 3, y: 3)
        .padding()
        .frame(width: 260)
    }
}

#Preview {
    @Previewable @State var showDetail = false
    HomeCategoryPage()
        
}
