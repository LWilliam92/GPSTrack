//
//  CustomUtils.swift
//  QPlus
//
//  Created by Kar Wai Ng on 05/07/2022.
//

import Foundation
import UIKit

class Utils: NSObject {
    class func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
}

func showAlertView(_ title: String, _ message: String, controller: UIViewController, popToRoot: Bool = false, completion: (() -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
        completion?()
        if popToRoot == true {
            controller.navigationController?.popToRootViewController(animated: true)
        }
    }))
    controller.present(alert, animated: true, completion: nil)
    return
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(origin: .zero, size: newSize)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}

func performLogout() {
    CoreSingletonData.shared.token = ""
    CoreSingletonData.shared.isLoggedIn = false
    let main = UIStoryboard(name: "Main", bundle: nil)
    let loginController = main.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    appDelegate.window?.rootViewController = UINavigationController(rootViewController: loginController)
//    appDelegate.window?.makeKeyAndVisible()
}
