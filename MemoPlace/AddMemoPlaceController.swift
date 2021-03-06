//
//  AddMemoPlaceController.swift
//  MemoPlace
//
//  Created by The Bao on 11/9/16.
//  Copyright © 2016 The Bao. All rights reserved.
//

import UIKit
import CoreData
class AddMemoPlaceController: UITableViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    var isVisited = true
    var memoPlace: MemoPlace!

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // Check selected YES,NO button
    @IBAction func selectBeenHereField(sender: UIButton) {

        switch sender.tag {
        case 1:
            yesButton.backgroundColor = UIColor.red
            noButton.backgroundColor = UIColor.gray

        case 2:
            isVisited = false
            noButton.backgroundColor = UIColor.red
            yesButton.backgroundColor = UIColor.gray

        default: break
        }
    }

    @IBAction func saveFilledInformations() {

        // Check required textField has been completed

        guard nameField.text?.isEmpty == false , typeField.text?.isEmpty == false, locationField.text?.isEmpty == false else {
            showAlert(title: "Can't Save", message: "Because name fields is blank. Please note that all fields are required.", style: .alert)
            return
        }
        // Add new restaurant to Database

        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        memoPlace = NSEntityDescription.insertNewObject(forEntityName: "MemoPlace", into: context) as! MemoPlace
        memoPlace.name = nameField.text
        memoPlace.type = typeField.text
        memoPlace.location = locationField.text
        memoPlace.phoneNumber = phoneField.text
        if let image = UIImagePNGRepresentation((imgView.image)!) {
            memoPlace.image = image as NSData?
        }
        memoPlace.isVisited = isVisited

        appDel.saveContext()

        // Segue
        performSegue(withIdentifier: "unwindToHomeScreen", sender: self)
        dismiss(animated: true, completion: nil)

    }
    // MARK: Alert Controller
    func showAlert(title: String?, message: String?, style: UIAlertControllerStyle) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}
// MARK: UITableView Delegate
extension AddMemoPlaceController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
// MARK:  UIImagePicker PROTOCOLS
extension AddMemoPlaceController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        imgView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        imgView.clipsToBounds = true

        // Auto Layout Constraints

        let leadingConstraint = NSLayoutConstraint(item: imgView, attribute: .leading, relatedBy: .equal, toItem: imgView.superview, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: imgView, attribute: .trailing, relatedBy: .equal, toItem: imgView.superview, attribute: .trailing, multiplier: 1.0, constant: 0)
        let topConstraint = NSLayoutConstraint(item: imgView, attribute: .top, relatedBy: .equal, toItem: imgView.superview, attribute: .top, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: imgView, attribute: .bottom, relatedBy: .equal, toItem: imgView.superview, attribute: .bottom, multiplier: 1.0, constant: 0)
        let constraints: [NSLayoutConstraint] = [leadingConstraint,trailingConstraint,topConstraint,bottomConstraint]
        _ = constraints.map { $0.isActive = true }
        
        
        dismiss(animated: true, completion: nil)
        
    }
}

