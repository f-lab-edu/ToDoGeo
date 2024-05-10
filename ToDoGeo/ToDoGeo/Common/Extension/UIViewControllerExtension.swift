//
//  UIViewControllerExtension.swift
//  ToDoGeo
//
//  Created by SUN on 5/10/24.
//

import UIKit

extension UIViewController {
    var topMostViewController : UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? tab
        }
        return self
    }
}
