//
//  ArtGivenViewController.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/23/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit
import Firebase

class ArtGivenViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ArtRequests.sendEmail(to: (Auth.auth().currentUser?.email)!, subject: "Thanks for your support!", text: "This email is confirmation for your art submission. If this was not you, contact us at this email. Thank you for your time!") { success in
            if !success {
                let retry = UIAlertAction(title: "Retry", style: .destructive, handler: { _ in
                    self.viewDidAppear(animated)
                })
                self.displayError(message: "Sending the email failed. Please try again later.", additionalActions: [retry])
            }
        }
    }

}
