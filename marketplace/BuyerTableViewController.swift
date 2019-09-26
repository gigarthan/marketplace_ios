//
//  BuyerTableViewController.swift
//  marketplace
//
//  Created by Gigarthan Vijayakumaran on 9/23/19.
//  Copyright © 2019 Gigarthan Vijayakumaran. All rights reserved.
//

import UIKit
import RealmSwift

class BuyerTableViewController: UITableViewController {
  @IBOutlet weak var itemsTable: UITableView!
  
  var itemsList: [Items] = [Items]()
  
    override func viewDidLoad() {
        super.viewDidLoad()

      itemsList = Array(try! Realm().objects(Items.self).sorted(byKeyPath: "id", ascending: false))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return itemsList.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buyerCell", for: indexPath) as! BuyerTableViewCell

        let row = itemsList[indexPath.row]
      
        cell.itemName.text = row.title
        cell.itemPrice.text = row.price

        return cell
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      guard let detailViewController = segue.destination as? BuyerDetailsViewController,
        let index = tableView.indexPathForSelectedRow?.row
        else {
          return
      }
      detailViewController.item = itemsList[index]
    }
}
