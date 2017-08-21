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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //UIApplication.shared.delegate?.window??.tintColor = UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        //UINavigationBar.appearance().barStyle = UIBarStyle.black
        //UINavigationBar.appearance().backgroundColor = UIColor.red
        //UINavigationBar.appearance().setBackgroundImage(theme.navigationBackgroundImage, forBarMetrics: .Default)
        
        FirebaseApp.configure()
        
        // Sign in config
        GIDSignIn.sharedInstance().clientID = "804071343462-ucf6grb3f6q3q7c4nfnilu3lftrsvide.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
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
        
        //print(user.profile.name)
        
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
