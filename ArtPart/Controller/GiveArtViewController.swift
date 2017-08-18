//
//  GiveArtViewController.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/16/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit

class GiveArtViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var selectedImages = [UIImage]()
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedImages.isEmpty {
            for _ in 0...tableView.numberOfRows(inSection: 0) {
                selectedImages.append(#imageLiteral(resourceName: "placeholder-image"))
            }
        }
        nameField.delegate = self
        descriptionField.delegate = self
    }


}

extension GiveArtViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
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
        guard let selectedIndexPath = tableView.indexPathForSelectedRow, let selectedRow = Optional(selectedIndexPath.row) else {
            return
        }
        selectedImages[selectedRow] = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        DispatchQueue.main.async {
            self.tableView.deselectRow(at: selectedIndexPath, animated: true)
            self.tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
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
