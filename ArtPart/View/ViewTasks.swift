//
//  ViewTasks.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/23/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayError(title: String = "Network error.", message: String, additionalActions: [UIAlertAction] = []) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok.", style: .default) { _ in
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
            }
        })
        
        for action in additionalActions {
            alert.addAction(action)
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}


extension UITabBarController {
    func addTab(tab vc: UIViewController, at index: Int, title: String, image: UIImage) {
        var currentTabs = self.viewControllers  // get vc's in tab controller
        currentTabs?.insert(vc, at: index)  // Add a vc
        
        self.setViewControllers(currentTabs, animated: true)
        configureTab(at: index, title: title, image: image)
    }
    
    func configureTab(at index: Int, title: String, image: UIImage) {
        self.tabBar.items?[index].title = title
        self.tabBar.items?[index].image = image
    }
}
