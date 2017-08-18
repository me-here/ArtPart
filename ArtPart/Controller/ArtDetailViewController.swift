//
//  ArtDetailViewController.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/17/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit

class ArtDetailViewController: UIViewController {
    @IBOutlet weak var artImage: UIImageView!
    var image: UIImage?
    
    @IBOutlet weak var artDescription: UITextView!
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = image {
            artImage.image = image
        }
        if let desc = desc {
            artDescription.text = desc
        }
    }
}
