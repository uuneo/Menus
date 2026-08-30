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

    // 保留兼容绑定(瀑布流不再使用点开展开)
    @Binding var show: Bool

    let warm: Color = [.red, .yellow, .orange, .pink].randomElement() ?? .red
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: 标题
            HStack(alignment: .top, spacing: 10) {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(Color.accentColor)
                    .frame(width: 5, height: 42)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 3) {
                    Text(data.title)
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    if !data.subTitle.isEmpty {
                        Text(data.subTitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer(minLength: 0)
                if data.header != "" {
                    Text(data.header)
                        .font(.caption2.bold())
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(warm.opacity(0.15)))
                        .foregroundStyle(warm)
                }
            }

            Divider().opacity(0.3)

            // MARK: 价格列表(A/B/C/D 从上至下), 统一配色
            VStack(spacing: 8) {
                if let p = data.prices.first(where: { $0.mode == .A }) {
                    PriceRow(price: p, value: priceHandler(item: p),
                             tint: Color.primary, filled: false)
                }
                if let p = data.prices.first(where: { $0.mode == .B }) {
                    PriceRow(price: p, value: priceHandler(item: p),
                             tint: Color.primary.opacity(0.7), filled: false)
                }
                if let p = data.prices.first(where: { $0.mode == .C }) {
                    PriceRow(price: p, value: priceHandler(item: p),
                             tint: Color.accentColor, filled: true)
                }
                if let p = data.prices.first(where: { $0.mode == .D }) {
                    PriceRow(price: p, value: priceHandler(item: p),
                             tint: Color.accentColor.opacity(0.85), filled: true)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))

                // 低透明度美发图标水印点缀
                Image(systemName: watermarkIcon)
                    .font(.system(size: 90, weight: .bold))
                    .foregroundStyle(Color.accentColor)
                    .opacity(0.06)
                    .padding(8)
                    .rotationEffect(.degrees(-12))
            }
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    // 根据项目内容选水印图标
    private var watermarkIcon: String {
        let t = data.title + data.subTitle
        if t.contains("烫") { return "flame" }
        if t.contains("染") || t.contains("色") { return "paintpalette" }
        if t.contains("护理") || t.contains("SPA") || t.contains("养护") { return "sparkles" }
        if t.contains("灸") || t.contains("调理") || t.contains("疗") { return "cross.case" }
        if t.contains("剪") || t.contains("造型") { return "scissors" }
        return "star.circle"
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

// MARK: - 单行价格(只渲染 prefix + 金额 + suffix)
private struct PriceRow: View {
    let price: PriceRealmData
    let value: Double
    let tint: Color
    var filled: Bool = false

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            if !price.name.isEmpty {
                Text(price.name)
                    .font(.subheadline.bold())
                    .foregroundStyle(filled ? .white : Color.primary)
            }

            Spacer(minLength: 8)

            HStack(alignment: .firstTextBaseline, spacing: 3) {
                if !price.prefix.isEmpty {
                    Text(price.prefix)
                        .font(.subheadline.bold())
                        .foregroundStyle(filled ? .white.opacity(0.85) : tint)
                }
                Text(String(format: "%.0f", value))
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundStyle(filled ? .white : tint)
                    .minimumScaleFactor(0.6)
                if !price.suffix.isEmpty {
                    Text(price.suffix)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(filled ? .white.opacity(0.85) : tint.opacity(0.7))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(filled
                      ? AnyShapeStyle(LinearGradient(
                          colors: [tint, tint.opacity(0.78)],
                          startPoint: .leading, endPoint: .trailing))
                      : AnyShapeStyle(Color(.tertiarySystemGroupedBackground)))
        )
    }
}

#Preview {
    @Previewable @State var show = true
    ProjectCardView(
        data: ItemRealmData(),
        show: $show
    )
}
