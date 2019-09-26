//
//  AddItemViewController.swift
//  marketplace
//
//  Created by Gigarthan Vijayakumaran on 9/23/19.
//  Copyright © 2019 Gigarthan Vijayakumaran. All rights reserved.
//

import UIKit
import RealmSwift
import Photos

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
  @IBOutlet weak var itemName: UITextField!
  @IBOutlet weak var itemDesc: UITextField!
  @IBOutlet weak var itemPrice: UITextField!
  @IBOutlet weak var itemImg: UIImageView!
  
  var imageUrl: String = ""
  var latitude: Double = 0.0
  var longitude: Double = 0.0
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  func isAllFieldsFilled() -> Bool {
    return (itemName.text?.isEmpty == false && itemDesc.text?.isEmpty == false && itemPrice.text?.isEmpty == false)
  }
  
  func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func saveToDB() {
    let realm = try! Realm()
    
    try! realm.write {
      let newItem = Items()
      newItem.id = newItem.incrementId()
      newItem.title = itemName.text!
      newItem.desc = itemDesc.text!
      newItem.price = itemPrice.text!
      newItem.longitude = longitude
      newItem.latitude = latitude
      newItem.img = imageUrl
      
      realm.add(newItem)
      print("Item Added")
    }
  }
  
  
  @IBAction func addItem(_ sender: Any) {
    if isAllFieldsFilled() {
      saveToDB()
      self.navigationController?.popViewController(animated: true)
    } else {
      showAlert(title: "Invalid Fields", message: "All the fields should be filled")
    }
  }
  

  @IBAction func selectImage(_ sender: Any) {
    showGallerySheet()
  }
  
  func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
    
    //Check is source type available
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      
      let imagePickerController = UIImagePickerController()
      imagePickerController.delegate = self
      imagePickerController.sourceType = sourceType
      self.present(imagePickerController, animated: true, completion: nil)
    }
  }
  
  func showGallerySheet() {
    
    let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
      self.getImage(fromSourceType: .camera)
    }))
    alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
      self.getImage(fromSourceType: .photoLibrary)
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
   
    if #available(iOS 11.0, *) {
      let imageNSUrl = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
      imageUrl = imageNSUrl?.relativeString ?? ""
      
    } else {
      // Fallback on earlier versions
    }
    
    let status = PHPhotoLibrary.authorizationStatus()
    
    if status == .notDetermined  {
      PHPhotoLibrary.requestAuthorization({status in
        if #available(iOS 11.0, *) {
          if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            if let photoCoordinate = asset.location?.coordinate {
              self.latitude = photoCoordinate.latitude
              self.longitude = photoCoordinate.longitude
            }
          }
        }
      })
    } else {
      if #available(iOS 11.0, *) {
        if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
          if let photoCoordinate = asset.location?.coordinate {
            latitude = photoCoordinate.latitude
            longitude = photoCoordinate.longitude
          }
        }
      }
    }
    
    
    
    
    itemImg.image = originalImage
    
    // Dismiss UIImagePickerController to go back to your original view controller
    dismiss(animated: true, completion: nil)
  }

}
