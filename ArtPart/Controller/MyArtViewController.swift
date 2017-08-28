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
    var artNumbers = [Int]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let myArtWorks = ref.child("Users/\(uid)/Artworks")
        
        artURLs.removeAll()
        descriptions.removeAll()
        numberOfArtWorks = 0
        
        myArtWorks.observe(.value, with: { snapshot in
            self.numberOfArtWorks = Int(snapshot.childrenCount)
            for value in snapshot.children {
                guard let artValue = value as? DataSnapshot, let artNumber = artValue.value as? Int else {continue}
                self.artNumbers.append(artNumber)
                
                ref.child("ArtPieces/\(artNumber)").observe(.value, with: { snapshot in
                    let artSnap = snapshot.value as? [String: AnyObject]
                    guard let description = artSnap?["description"] as? String,
                    let artWorkURLS = artSnap?["PicturesOfArtWork"] as? [String: AnyObject],
                    let firstPic = artWorkURLS["pic1"] as? String else {
                        return
                    }
                    
                    self.descriptions.append(description)
                    self.artURLs.append(firstPic)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
                
            }
            
        })
        
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        let editing = tableView.isEditing ? false: true
        DispatchQueue.main.async {
            self.tableView.setEditing(editing, animated: true)
        }
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

extension MyArtViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let number = artNumbers[indexPath.row]
        Database.database().reference().child("ArtPieces/\(number)").removeValue()
        
        descriptions.remove(at: indexPath.row)
        artURLs.remove(at: indexPath.row)
        artNumbers.remove(at: indexPath.row)
        numberOfArtWorks -= 1
        DispatchQueue.main.async {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
