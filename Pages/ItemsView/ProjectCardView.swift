//
//  ProjectCardView.swift
//  PeacockMenus
//
//  Created by Neo on 2025/11/27.
//
import RealmSwift
import SwiftUI

struct ProjectCardView: View {
   @State private var manager = peacock.shared

    @ObservedRealmObject var data: ItemRealmData

    @Binding var show: Bool

    let color1: Color = [.blue, .green, .teal, .cyan, .mint].randomElement() ?? .blue
    let color2: Color = [.red, .yellow, .orange, .pink].randomElement() ?? .red

    @State private var textColor: Color = .black

    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = .current
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }

    @State private var width: CGFloat = 330

    var height: CGFloat {
        if data.show(.A, .B) && data.show(.C, .D) {
            return show ? 220 : 180
        }
        return 180
    }

    var showCorse: Bool {
        return data.show(.C, .D) && !data.show(.A, .B) ? true : show
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(data.title)
                            .font(ISPAD ?.title : .title2)
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

                Spacer(minLength: 0)

                if showCorse && data.show(.C, .D) {
                    HStack {
                        if let price = data.prices.first(where: { $0.mode == .C }) {
                            HStack {
                                Spacer()
                                Text(price.prefix)
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 15))
                                    .bold()
                                    .minimumScaleFactor(0.6)

                                Text(
                                    String(
                                        format: "%.0f",
                                        priceHandler(item: price)
                                    )
                                )
                                .bold()
                                .font(.system(size: 25))
                                .minimumScaleFactor(0.6)
                                .foregroundStyle(color2)

                                Text(price.suffix)
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 15))
                                    .bold()
                                    .minimumScaleFactor(0.6)
                                Spacer()
                            }
                        }
                        if let price = data.prices.first(where: { $0.mode == .D }) {
                            Divider()
                                .background(Color.background)

                            HStack {
                                Spacer()

                                Text(price.prefix)
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 15))
                                    .bold()
                                    .minimumScaleFactor(0.6)
                                Text(String(format: "%.0f", priceHandler(item: price)))
                                    .bold()
                                    .font(.system(size: 25))
                                    .minimumScaleFactor(0.6)
                                    .foregroundStyle(color1)
                                Text(price.suffix)
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 15))
                                    .bold()
                                    .minimumScaleFactor(0.6)
                                Spacer()
                            }
                        }
                    }

                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.shadow1, radius: 5, x: 10, y: 10)
                    .shadow(color: Color.shadow2, radius: 1, x: -1, y: -1)
                    .frame(height: 60)
                    .transition(
                        .move(edge: .bottom)
                            .combined(with: .opacity)
                            .animation(.easeInOut(duration: 0.3))
                    )
                }

                HStack {
                    if let price = data.prices.first(where: { $0.mode == .A }) {
                        HStack {
                            Text(price.prefix)
                                .font(.system(size: 15))
                                .foregroundStyle(.gray)
                                .minimumScaleFactor(0.6)
                            Text(String(format: "%.0f", priceHandler(item: price)))
                                .bold()
                                .font(.system(size: 25))
                                .minimumScaleFactor(0.6)
                            Text(price.suffix)
                                .font(.system(size: 15))
                                .foregroundStyle(.gray)
                                .minimumScaleFactor(0.6)
                        }
                    }

                    Spacer()

                    if let price = data.prices.first(where: { $0.mode == .B }) {
                        HStack {
                            Text(price.prefix)
                                .font(.system(size: 15))
                                .foregroundStyle(.gray)
                                .minimumScaleFactor(0.6)
                            Text(String(format: "%.0f", priceHandler(item: price)))
                                .bold()
                                .font(.system(size: 25))
                                .minimumScaleFactor(0.6)
                                .foregroundStyle(Color.cyan)

                            Text(price.suffix)
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
            .frame(width: width, height: height)
            .background(.ultraThinMaterial)
            .overlay {
                if data.header != "" {
                    VStack {
                        HStack {
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
        .animation(.easeInOut, value: showCorse)
    }

    func priceHandler(item: PriceRealmData) -> Double {
        let select = manager.selectCardData

        if item.discount {
            switch item.mode {
            case .A, .B:
                return Double(item.money) * select.discount
            case .C, .D:
                return Double(item.money) * select.discount2
            }
        } else {
            return Double(item.money)
        }
    }
}

#Preview {
    @Previewable @State var show = true
    ProjectCardView(
        data: ItemRealmData(),
        show: $show
    )
    
}
