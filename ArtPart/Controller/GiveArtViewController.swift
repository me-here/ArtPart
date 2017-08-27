//
//  GiveArtViewController.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/16/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class GiveArtViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    
    var selectedImages = [UIImage]()
    var imageURLS = [String]()
    var key = ""
    var needsNewKey: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if selectedImages.isEmpty {
            for _ in 0...tableView.numberOfRows(inSection: 0) - 1 {
                selectedImages.append(#imageLiteral(resourceName: "placeholder-image"))
            }
        }
        
        descriptionField.delegate = self
        priceField.delegate = self
        priceField.keyboardType = .decimalPad
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if needsNewKey {
            key = "\(Int(arc4random_uniform(1000000000)))"   // They most likely won't have 1,000,000,000 pieces of art and the possibility of a conflict is infinitesemaly low...
            needsNewKey = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        needsNewKey = true
    }

    @IBAction func submitArtwork(_ sender: Any) {
        // checks
        guard let price = Int(priceField.text ?? ""),
            let uid = Auth.auth().currentUser?.uid,
            let desc = descriptionField.text else {
            // Alert
            displayError(title: "Empty fields..", message: "Please enter a price and description.", additionalActions: [])
            return
        }
        
        for image in selectedImages {
            if image == #imageLiteral(resourceName: "placeholder-image") {
                // Alert
                displayError(title: "Image not selected.", message: "Select all 3 images please.", additionalActions: [])
                return
            }
        }
        
        
        
        // database POST
        let root = Database.database().reference()
        //let key = root.child("ArtPieces").childByAutoId().key
        
        let images = ["pic1": imageURLS[0],
                      "pic2": imageURLS[1],
                      "pic3": imageURLS[2]
                      ]
        
        let post = [
            "Artist": uid,
            "desiredPrice": price,
            "PicturesOfArtWork": images,
            "description": desc
            ] as [String : Any]
        let childUpdates = ["ArtPieces/\(key)": post]
        root.updateChildValues(childUpdates)
        // Add images to Storage
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "success", sender: self)
        }
    }
    
}

extension GiveArtViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imagePicker = UIImagePickerController()
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) || UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { // One of the sourceTypes should work
            displayError(title: "Source types not available", message: "Camera and photo album are not working", additionalActions: [])
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        //UserDefaults.
        imagePicker.delegate = self
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
}

extension GiveArtViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pictureCell", for: indexPath)
        
        cell.imageView?.image = selectedImages[indexPath.row]
        if cell.imageView?.image == #imageLiteral(resourceName: "placeholder-image") {
            cell.textLabel?.text = "\(indexPath.row)'st image not selected"
        } else {
            cell.textLabel?.text = "Selected \(indexPath.row)'st image."
        }
        
        return cell
    }
    
}

extension GiveArtViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let uid = Auth.auth().currentUser?.uid, !uid.isEmpty,
            let selectedIndexPath = tableView.indexPathForSelectedRow,
            let selectedRow = Optional(selectedIndexPath.row),
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imageData: Data = UIImageJPEGRepresentation(image, 0.4) else {
            return
        }
        
        selectedImages[selectedRow] = image
        
        // Firebase Storage --> Store images
        let storageRoot = Storage.storage().reference()
        let currentUserImages = storageRoot.child("images/\(Auth.auth().currentUser?.uid ?? "")/\(key)/\(selectedRow).jpg")
        
        currentUserImages.putData(imageData, metadata: nil, completion: { (metadata, error) in
            guard let metadata = metadata,
                let downloadString = metadata.downloadURL()?.absoluteString else {
                // analytics
                return
            }
            
            self.imageURLS.append(downloadString)
        })
        
        needsNewKey = false
        
        DispatchQueue.main.async {
            self.tableView.deselectRow(at: selectedIndexPath, animated: true)
            self.tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else {
            return
        }
        
        needsNewKey = false
        
        DispatchQueue.main.async {
            self.tableView.deselectRow(at: selectedIndexPath, animated: true)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension GiveArtViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
