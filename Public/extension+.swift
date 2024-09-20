//
//  shape+.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import Foundation
import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = 10
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


struct MenuButton: View {
    
    @Binding var show: Bool
    
    var body: some View {
        return ZStack(alignment: .topTrailing) {
            Button(action: { self.show.toggle() }) {
                HStack {
                    Image(systemName: "list.dash")
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.leading, 18)
                .frame(width: 90, height: 60)
                .background(Color("button"))
                .cornerRadius(30)
                .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 20)
            }
            Spacer()
        }
    }
}


extension Color{
    init(from comm: String) {
        // 判断是否是十六进制颜色代码
        if comm.hasPrefix("#") || comm.range(of: "^[0-9A-Fa-f]{3,8}$", options: .regularExpression) != nil {
            self = Color(hex: comm)
        } else {
            // 默认作为资源名称初始化
            self = Color(comm)
        }
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0) // 处理无效输入，默认白色
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


struct BlurView: UIViewRepresentable {

   let style: UIBlurEffect.Style

   func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
      let view = UIView(frame: .zero)
      view.backgroundColor = .clear
      let blurEffect = UIBlurEffect(style: style)
      let blurView = UIVisualEffectView(effect: blurEffect)
      blurView.translatesAutoresizingMaskIntoConstraints = false
      view.insertSubview(blurView, at: 0)
      NSLayoutConstraint.activate([
         blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
         blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
      ])
      return view
   }

   func updateUIView(_ uiView: UIView,
                     context: UIViewRepresentableContext<BlurView>) {}
}



struct FontAnimation: Animatable, ViewModifier{
    
    var size:Double
    var weight:Font.Weight
    var design:Font.Design
    var animatableData: Double{
        get { size }
        set { size = newValue }
    }
    
    func body(content: Content) -> some View {
        content.font(.system(size: size,weight: weight,design: design))
    }
    
}

extension View {
    func animationFont(size:Double,weight: Font.Weight = .regular,design:Font.Design = .default )-> some View{
        self.modifier(FontAnimation(size: size, weight: weight, design: design))
    }
    
}


extension URLSession{
    enum APIError:Error{
        case invalidURL
        case invalidCode(Int)
    }
    
    
    func data(for urlRequest:URLRequest) async throws -> Data{
        let (data,response) = try await self.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else{ throw APIError.invalidURL }
        guard 200...299 ~= response.statusCode else {throw APIError.invalidCode(response.statusCode) }
        return data
    }
  
}
