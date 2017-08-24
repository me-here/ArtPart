//
//  SettingsViewController.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/16/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit
import GoogleSignIn

class SettingsViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 { // Terms and conditions
                viewDetail(text: "Terms and conditions here...")
            }
            
            if indexPath.row == 1 { // Attributions
                viewDetail(text: "Icons made by madebyoliver, Gregor Cresnar, and freepik from Flaticon.")
            }
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            print("Sign out")
            GIDSignIn.sharedInstance().signOut()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func viewDetail(text: String) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailVC.text = text
        DispatchQueue.main.async {
            self.show(detailVC, sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
