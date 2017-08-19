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
    @IBOutlet weak var artFlowLayout: UICollectionViewFlowLayout!
    
    var numberOfArtWorks: Int  = 0
    var artworks: [[String: AnyObject]] = [[:]]
    var prices = [String]()
    var descriptions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFlowLayout(flowLayout: artFlowLayout, numberOfHorItems: 3, numberOfVertItems: 5, spacing: 3.0)
        
        ref = Database.database().reference()
        
        let url = ref.child("ArtPieces")
        url.observe(.value) { snapshot in
            self.numberOfArtWorks = Int(snapshot.childrenCount)
            for child in snapshot.children {
                let childSnapshot = child as? DataSnapshot
                let childDict = childSnapshot?.value as? [String: AnyObject]
                
                guard let price = childDict?["desiredPrice"] as? Double else {
                    // analytics
                    continue
                }
                
                let formattedPrice = String(format: "%.2f", price)
                self.prices.append(formattedPrice)  // If zero, something went wrong.
                
                guard let description = childDict?["description"] as? String else {
                    // analytics
                    continue
                }
                
                //print(description)
                self.descriptions.append(description)
                
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
            
        }
    }
    
    func setupFlowLayout(flowLayout: UICollectionViewFlowLayout, numberOfHorItems: CGFloat, numberOfVertItems: CGFloat, spacing: CGFloat) {
        artFlowLayout.minimumInteritemSpacing = spacing
        artFlowLayout.minimumLineSpacing = spacing
        
        let widthSize = (view.frame.width - 2 * artFlowLayout.minimumInteritemSpacing) / numberOfHorItems
        let heightSize = (view.frame.height - 2 * artFlowLayout.minimumLineSpacing) / numberOfVertItems   // not necessary unless you need it
        artFlowLayout.itemSize = CGSize(width: widthSize, height: heightSize)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewArt" {
            guard let firstSelectedRow = artCollectionView.indexPathsForSelectedItems?.first?.row else {
                return
            }
            let detailVC = segue.destination as! ArtDetailViewController
            
            detailVC.desc = descriptions[firstSelectedRow]
            let cell = artCollectionView.cellForItem(at: (artCollectionView.indexPathsForSelectedItems?.first)!) as! ArtCollectionViewCell
            detailVC.image = cell.artImage.image
            DispatchQueue.main.async {
                self.artCollectionView.deselectItem(at: (self.artCollectionView.indexPathsForSelectedItems?.first)!, animated: true)
            }
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "viewArt", sender: self)
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.numberOfArtWorks)
        return self.numberOfArtWorks
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtCollectionViewCell", for: indexPath) as! ArtCollectionViewCell
        
        
        let photURL = self.artworks[indexPath.row + 1]["pic1"]  // Firebase starts @ 1
        guard let photoURL = photURL as? String else {
            // Analytics ...
            return cell
        }
        ArtRequests.requestWith(requestType: "GET", requestURL: photoURL, addValues: [:], httpBody: nil, completionHandler: { data, error in
            guard error == nil else {
                print("ERROR")
                return
            }
            DispatchQueue.main.async {
                cell.artImage.image = UIImage(data: data!)
            }
        })
        
        // get cell data async and populate it
        //cell.artImage.image = #imageLiteral(resourceName: "settings")
        cell.suggestedPrice.text = "$\(prices[indexPath.row])"
        
        return cell
    }
    
}
