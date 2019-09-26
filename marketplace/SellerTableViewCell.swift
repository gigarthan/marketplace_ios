//
//  BuyerTableViewCell.swift
//  marketplace
//
//  Created by Gigarthan Vijayakumaran on 9/23/19.
//  Copyright © 2019 Gigarthan Vijayakumaran. All rights reserved.
//

import UIKit

class SellerTableViewCell: UITableViewCell {
  @IBOutlet weak var itemName: UILabel!
  @IBOutlet weak var itemDescription: UILabel!
  @IBOutlet weak var itemPrice: UILabel!
  @IBOutlet weak var itemImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
