//
//  AppDelegate.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/16/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    struct AppProperties {
        static let FirebaseClientID = "804071343462-ucf6grb3f6q3q7c4nfnilu3lftrsvide.apps.googleusercontent.com"
        static let orangeTabColor = UIColor(red: 242/255, green: 174/255, blue: 110/255, alpha: 1.0)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.delegate?.window??.tintColor = AppProperties.orangeTabColor
        
        FirebaseApp.configure()
        
        // Sign in config
        GIDSignIn.sharedInstance().clientID = AppProperties.FirebaseClientID
        GIDSignIn.sharedInstance().delegate = self
        
        if UserDefaults.standard.value(forKey: DefaultSettings.source) == nil { // No sourceType yet
            UserDefaults.standard.setValue(0, forKey: DefaultSettings.source)
        }   // have sourcetype
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }

}

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            // Analytics
            print("Sign in failure.")
            return
        }
        
        guard let authentication = user.authentication else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) {  (usr, err) in
            guard err == nil else {
                print("Firebase Sign in failure")
                print(err?.localizedDescription ?? "")
                return
            }
            
            // Yay sign in successful
        }
    }
}
