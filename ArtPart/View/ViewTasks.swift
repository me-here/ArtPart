//
//  ViewTasks.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/23/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayError(message: String, additionalActions: [UIAlertAction] = []) {
        let alert = UIAlertController(title: "Network error.", message: message, preferredStyle: .alert)
        
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
