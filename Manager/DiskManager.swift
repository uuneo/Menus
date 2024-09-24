//
//  DiskManageer.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/5.
//

import Foundation
import Defaults
import SwiftUI
import Alamofire
import JDStatusBarNotification

enum Page:String,Identifiable, CaseIterable{
	case home = "house.circle"
	case setting = "gear.circle"
	case photo = "photo.artframe.circle"
	var id: String { self.rawValue }
}



final class peacock:ObservableObject {
    
    static let shared = peacock()
    
    private init() { }
	
    
    @Published var selectedItem: CategoryData = CategoryData.example
    
    @Published var selectCard:MemberCardData = MemberCardData.nonmember
	
    
	@Published var page :Page = .home
	
	@Published var showMenu:Bool = false
	
    
    
    func updateItem(url:String,completion:((Bool) -> Void)? = nil){
        
        if !startsWithHttpOrHttps(url){
			Task{
				await self.toast("地址不正确", mode: .light)
			}
			
            completion?(false)
            return
        }
        
		Task{
			
			getData(url: url) { (result: TotalData?) in
			
				Task{
					if let data = result{
						await self.importData(totaldata: data)
						await self.toast("更新成功", mode: .success)
						completion?(true)
					}else{
						await self.toast("更新失败", mode: .matrix)
						completion?(false)
					}
				}
			}
			
			
        }
        
    }
    
    
    func uploadItem(url:String, completion:((Bool) -> Void)? = nil){
        if !startsWithHttpOrHttps(url){
            completion?(false)
        }
		
		uploadFile(url: url,completion: completion)
        
		
    }
    
    
    func startsWithHttpOrHttps(_ urlString: String) -> Bool {
        let pattern = "^(http|https)://.*"
        let test = NSPredicate(format:"SELF MATCHES %@", pattern)
        return test.evaluate(with: urlString)
    }
    

    
	func uploadFile(url: String, completion: ((Bool)->Void)?) {
		
		
		
		if let fileURL = saveJSONToTempFile(object: self.exportTotalData(), fileName: "menus"),
			let requestUrl = URL(string: url) {
			
			var request = URLRequest(url: requestUrl)
			request.httpMethod = HTTPMethod.post.rawValue
			request.cachePolicy = .reloadIgnoringLocalCacheData // 禁用缓存
			
			
			AF.upload(multipartFormData: { multipartFormData in
				// 添加文件数据
				multipartFormData.append(fileURL, withName: "file", fileName: fileURL.lastPathComponent, mimeType: "application/json")
			}, with: request)
			.responseDecodable(of: [String: Bool].self) { response in
				switch response.result {
				case .success(let data):
					debugPrint(data)
					completion?(data["status"] ?? false)
				case .failure(let err):
					debugPrint(err)
					completion?(false)
				}
			}
			
		}else{
			completion?(false)
		
		}
		
	}
    
    
	func getData<T: Codable>(url: String, completion: @escaping (T?)-> Void) {
		
		
		
		if let requestUrl = URL(string: url){
			
			var request = URLRequest(url: requestUrl)
			request.httpMethod = HTTPMethod.get.rawValue
			request.cachePolicy = .reloadIgnoringLocalCacheData
			
			AF.request(request).responseDecodable(of: T.self) { response in
				
				switch response.result{
				case .success(let data):
					completion(data)
				case .failure(_):
					completion(nil)
				}
			}
		}else{
			completion(nil)
		}
		
		
		
	}
	

}

extension peacock{
	func exportTotalData() -> TotalData{
		
		TotalData(
			Cards: Defaults[.Cards], Categorys: Defaults[.Categorys], Subcategorys: Defaults[.Subcategorys],
			Items: Defaults[.Items], menusName: Defaults[.menusName], menusSubName: Defaults[.menusSubName],
			menusFooter: Defaults[.menusFooter], menusImage: Defaults[.menusImage], homeCardTitle: Defaults[.homeCardTitle],
			homeCardSubTitle: Defaults[.homeCardSubTitle], homeItemsTitle: Defaults[.homeItemsTitle], homeItemsSubTitle: Defaults[.homeItemsSubTitle],
			settingPassword: Defaults[.settingPassword], autoSetting: Defaults[.autoSetting]
		)
	}
	
	func exportData() -> String{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(exportTotalData())
        return String(data: data, encoding: .utf8)!
    }
    
    func saveJSONToTempFile<T: Encodable>(object: T, fileName: String) -> URL? {
        // 获取临时目录
        let tempDirectory = FileManager.default.temporaryDirectory
        
        // 创建临时文件的 URL
        let tempFileURL = tempDirectory.appendingPathComponent(fileName).appendingPathExtension("json")
        
        do {
            // 创建 JSON 编码器
            let encoder = JSONEncoder()
            // 将对象编码为 JSON 数据
            let jsonData = try encoder.encode(object)
            
            // 写入 JSON 数据到临时文件
            try jsonData.write(to: tempFileURL, options: .atomic)
            
            // 返回文件 URL
            return tempFileURL
        } catch {
            // 捕获并打印错误
            print("Error saving JSON file: \(error.localizedDescription)")
            return nil
        }
    }
    
    @MainActor func importData(text:String) -> Bool{
        let decoder = JSONDecoder()
        let data = text.data(using: .utf8)!
        do{
            let totalData = try decoder.decode(TotalData.self, from: data)
            importData(totaldata: totalData)
            return true
        }catch{
            return false
        }
    }
    
    @MainActor func importData(totaldata:TotalData){
        let cards = totaldata.Cards
        let categorys = totaldata.Categorys
        let subcategorys = totaldata.Subcategorys
        let items = totaldata.Items
        let title =   totaldata.homeCardTitle
        let subTitle =  totaldata.homeCardSubTitle
        let itemTitle =  totaldata.homeItemsTitle
        let itemSubtitle =  totaldata.homeItemsSubTitle
        let setting =  totaldata.autoSetting
        let password =  totaldata.settingPassword
		let menusName = totaldata.menusName
		let menusFooter = totaldata.menusFooter
		let menusImage = totaldata.menusImage
		let subName = totaldata.menusSubName
		
		
        
        
        if !cards.isEmpty{
            Defaults[.Cards] = cards
			
        }
        
        if !categorys.isEmpty{
            Defaults[.Categorys] = categorys
			
        }
        
        if !subcategorys.isEmpty{
            Defaults[.Subcategorys] = subcategorys
        }
        
        if !items.isEmpty{
            Defaults[.Items] = items
        }
        
        if let title = title{
            Defaults[.homeCardTitle] = title
        }
        
        if let subTitle = subTitle{
            Defaults[.homeCardSubTitle] = subTitle
        }
        
        if let itemTitle = itemTitle{
            Defaults[.homeItemsTitle] = itemTitle
        }
        
        if let itemSubtitle = itemSubtitle{
            Defaults[.homeItemsSubTitle] = itemSubtitle
        }
        
        if let setting = setting{
            Defaults[.autoSetting] = setting
        }
        
        if let password = password{
            Defaults[.settingPassword] = password
            
        }
		
		if let menusName = menusName{
			Defaults[.menusName] = menusName
		}
		
		if let menusFooter = menusFooter{
			Defaults[.menusFooter] = menusFooter
		}
		
		if let menusImage = menusImage{
			Defaults[.menusImage] = menusImage
		}
		
		if let subName = subName{
			Defaults[.menusSubName] = subName
		}
    }
	
	@MainActor
	func toast(_ message:String,mode:IncludedStatusBarNotificationStyle = .defaultStyle,duration:Double = 1.6){
		
		NotificationPresenter.shared.present(message, includedStyle: mode, duration: duration) { presenter in
		  presenter.animateProgressBar(to: 1.0, duration: 0.75) { presenter in
			presenter.dismiss()
		  }
		}
		
		
		
	}
}

extension peacock{
    
    
    func removeCategoryItems(indexSet:IndexSet){
        
        for index in indexSet{
            let item = Defaults[.Categorys][index]
            Defaults[.Categorys].remove(at: index)
            Defaults[.Items] = Defaults[.Items].filter({$0.categoryId == item.id})
        }
    }
    
    func removeSubcategoryItems(indexSet:IndexSet){
        
        for index in indexSet{
            let item = Defaults[.Subcategorys][index]
            Defaults[.Subcategorys].remove(at: index)
            Defaults[.Items] = Defaults[.Items].filter{$0.subcategoryId != item.id}
        }
    }
    
    func removeItems(indexSet:IndexSet){
        
        for index in indexSet{
            Defaults[.Items].remove(at: index)
        }
    }
    
}
