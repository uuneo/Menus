//
//  ActionViewController.swift
//  PeacockActionExtension
//
//  Created by He Cho on 2024/9/16.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import UIKit

class ActionViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        extensionContext?.open(URL(string: "ppeacock://123")!, completionHandler: nil)
        
    }
}


//class ActionViewController: UIViewController {
//
//    @IBOutlet weak var imageView: UIImageView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Get the item[s] we're handling from the extension context.
//
//        // For example, look for an image and place it into an image view.
//        // Replace this with something appropriate for the type[s] your extension supports.
//        var imageFound = false
//        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
//            for provider in item.attachments! {
//                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
//                    // This is an image. We'll load it, then place it in our image view.
//                    weak var weakImageView = self.imageView
//                    provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil, completionHandler: { (imageURL, error) in
//                        OperationQueue.main.addOperation {
//                            if let strongImageView = weakImageView {
//                                if let imageURL = imageURL as? URL {
//                                    strongImageView.image = UIImage(data: try! Data(contentsOf: imageURL))
//                                }
//                            }
//                        }
//                    })
//
//                    imageFound = true
//                    break
//                }
//            }
//
//            if (imageFound) {
//                // We only handle one image, so stop looking for more.
//                break
//            }
//        }
//    }
//
//    @IBAction func done() {
//        // Return any edited content to the host app.
//        // This template doesn't do anything, so we just echo the passed in items.
//        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
//    }
//
//}
