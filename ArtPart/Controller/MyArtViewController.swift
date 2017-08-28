//
//  MyArtViewController.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/27/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit
import Firebase

class MyArtViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var numberOfArtWorks = 0
    var descriptions = [String]()
    var artURLs = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let myArtWorks = ref.child("Users/\(uid)/Artworks")
        
        
        myArtWorks.observe(.value, with: { snapshot in
            self.numberOfArtWorks = Int(snapshot.childrenCount)
            for value in snapshot.children {
                guard let artValue = value as? DataSnapshot, let artNumber = artValue.value as? Int else {continue}
                
                ref.child("ArtPieces/\(artNumber)").observe(.value, with: { snapshot in
                    let artSnap = snapshot.value as? [String: AnyObject]
                    guard let description = artSnap?["description"] as? String,
                    let artWorkURLS = artSnap?["PicturesOfArtWork"] as? [String: AnyObject],
                    let firstPic = artWorkURLS["pic1"] as? String else {
                        return
                    }
                    
                    self.descriptions.append(description)
                    self.artURLs.append(firstPic)
                    
                    self.tableView.reloadData()
                })
                
            }
            
        })
        
    }
    
}


extension MyArtViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artCell", for: indexPath)
        
        cell.imageView?.image = #imageLiteral(resourceName: "placeholder-image")
        
        guard !artURLs.isEmpty && indexPath.row < descriptions.count else {return cell}
        
        ArtRequests.requestWith(requestType: .get, requestURL: artURLs[indexPath.row], addValues: [:], httpBody: nil, completionHandler: { data, error in
            guard error == nil else {
                print("ERROR")
                self.displayError(message: "Failure populating images.")
                return
            }
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: data!)
            }
        })
        
        if !descriptions.isEmpty && indexPath.row < descriptions.count {
            cell.textLabel?.text = descriptions[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfArtWorks
    }
}
