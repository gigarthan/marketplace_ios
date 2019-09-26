//
//  BuyerDetailsViewController.swift
//  marketplace
//
//  Created by Gigarthan Vijayakumaran on 9/26/19.
//  Copyright © 2019 Gigarthan Vijayakumaran. All rights reserved.
//

import UIKit
import Photos

class BuyerDetailsViewController: UIViewController {
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var latitude: UILabel!
  @IBOutlet weak var longitude: UILabel!
  @IBOutlet weak var itemDescription: UILabel!
  
  var item: Items?
  
    override func viewDidLoad() {
        super.viewDidLoad()

      print("dasdas")
      print(item)
      name.text = item?.title
      price.text = item?.price
      latitude.text = item?.latitude.description
      longitude.text = item?.longitude.description
      itemDescription.text = item?.desc
      
      let status = PHPhotoLibrary.authorizationStatus()
      
      if status == .notDetermined  {
        PHPhotoLibrary.requestAuthorization({status in
          
        })
      }
      
      if let img = item?.img {
        let url = URL(string: img)
        if let url = url {
          let data = try? Data(contentsOf: url)
          if let data = data {
            image.image = UIImage(data: data)
          }
        }
      }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
