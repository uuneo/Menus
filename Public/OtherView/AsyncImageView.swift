//
//  AsyncImageView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/4.
//

import SwiftUI

struct AsyncImageView: View {
    
    var imageUrl:String?
    
    
    @State private var success:Bool = true
    
    @State private var image: UIImage?
    
    
    var body: some View {
        
        VStack{
            if let imageUrl = imageUrl, isValidURL(imageUrl), success{
                if let image = image {
                    // 如果已经加载了图片，则显示图片
                    
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.original)
                    
                } else {
                    // 如果图片尚未加载，则显示加载中的视图
                    ProgressView()
                    
                }
            }else{
                Image(imageUrl ?? "peacock3")
                    .resizable()
                    .renderingMode(.original)
            }
            
        }
        
        .onChange(of: imageUrl) { _, newValue in
            loadImage(icon: newValue)
        }
        .onAppear {
            loadImage(icon: imageUrl)
        }
        
    }
    
    private func isValidURL(_ string: String) -> Bool {
        // 尝试将字符串转换为 URL 对象
        guard let url = URL(string: string) else { return false }
        
        // 检查 URL 对象是否有 scheme 和 host
        return url.scheme != nil && url.host != nil
    }
    private func loadImage(icon:String? ) {
        self.image = nil
        
        guard let icon = icon, isValidURL(icon) else {
            self.success = false
            return
        }
        
        Task {
            if let imagePath = await ImageManager.downloadImage(icon) {
                DispatchQueue.main.async {
                    self.image = UIImage(contentsOfFile: imagePath)
                }
            } else {
                DispatchQueue.main.async {
                    self.success = false
                }
            }
        }
    }
}
