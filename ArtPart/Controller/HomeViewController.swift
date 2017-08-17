//
//  HomeViewController.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/16/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController {
    var ref: DatabaseReference!
    @IBOutlet weak var artCollectionView: UICollectionView!
    
    var numberOfArtWorks: Int  = 0
    var artworks: [[String: AnyObject]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        let url = ref.child("ArtPieces")
        url.observe(.value) { snapshot in
            self.numberOfArtWorks = Int(snapshot.childrenCount)
            for child in snapshot.children {
                let artworkSnapshot = (child as? DataSnapshot)?.childSnapshot(forPath: "PicturesOfArtWork")
                guard let artworkURLS = artworkSnapshot?.value as? [String: AnyObject] else {
                    continue
                }
                print(artworkURLS["pic1"] ?? "")
                self.artworks.append(artworkURLS)
                DispatchQueue.main.async {
                    self.artCollectionView.reloadData()
                }
            }/*
            if !self.artworks.isEmpty {
                //  get photos
                
            }*/
            
            DispatchQueue.main.async {
                
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        <#code#>
    }*/
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.numberOfArtWorks)
        return self.numberOfArtWorks
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtCollectionViewCell", for: indexPath) as! ArtCollectionViewCell
        
        // get cell data async and populate it
        cell.artImage.image = #imageLiteral(resourceName: "settings")
        cell.suggestedPrice.text = "$2.00"
        
        return cell
    }
    
}
