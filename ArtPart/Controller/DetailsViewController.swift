//
//  DetailsViewController.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/23/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var textField: UITextView!
    var text: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings-Detail"
        textField.isEditable = false
        textField.isSelectable = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let text = text {
            textField.text = text
        }
    }
}
