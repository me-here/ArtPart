//
//  LoginViewController.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/16/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ArtRequests.sendEmail(to: "mihirthanekar@gmail.com", subject: "Hi!", text: "Some time no see! We should meet up soon.")
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            print("Transition VC's")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
        
    }
}

extension LoginViewController: GIDSignInUIDelegate {
    
    
}


