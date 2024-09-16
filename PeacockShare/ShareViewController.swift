//
//  ShareViewController.swift
//  PeacockShare
//
//  Created by He Cho on 2024/9/16.
//

import UIKit
import MobileCoreServices
import Social
import SwiftUI

class ShareViewController: UIViewController {
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getImageDataFromExtension()
    }
}

extension ShareViewController {
    private func getImageDataFromExtension() {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let extensionAttachments = item.attachments else { return }
        
        for provider in extensionAttachments {
            provider.loadItem(forTypeIdentifier: "public.image") { data, _ in
                if let fileUrl = data as? URL {
                    self.open(url: fileUrl)
                    
                    self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
                } else {
                    self.extensionContext?.cancelRequest(withError: ActionError.failedTorCopyTempFile)
                }
            }
        }
    }
    
  private func open(url: URL) {
        var responder: UIResponder? = self as UIResponder
        let selector = #selector(openURL(_:))
        
        while responder != nil {
            if responder!.responds(to: selector) && responder != self {
                responder!.perform(selector, with: url)
                
                return
            }
            responder = responder?.next
        }
    }
  
    @objc
    private func openURL(_ url: URL) {
        return
    }
}
