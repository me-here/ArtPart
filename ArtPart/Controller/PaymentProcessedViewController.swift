//
//  PaymentProcessedViewController.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/23/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit
import Firebase

class PaymentProcessedViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ArtRequests.sendEmail(to: (Auth.auth().currentUser?.email)!, subject: "Hi!", text: "Congrats on your purchase!")
    }

}
