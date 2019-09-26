//
//  SellerTableViewController.swift
//  marketplace
//
//  Created by Gigarthan Vijayakumaran on 9/23/19.
//  Copyright © 2019 Gigarthan Vijayakumaran. All rights reserved.
//

import UIKit
import RealmSwift

class SellerTableViewController: UITableViewController {
  var itemsList: [Items] = [Items]()
  var notificationToken: NotificationToken? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
      let itemsResults = try! Realm().objects(Items.self).sorted(byKeyPath: "id", ascending: false)
      itemsList = Array(itemsResults)
      
      notificationToken = itemsResults.observe { [weak self]
        (changes: RealmCollectionChange) in
        guard let tableView = self?.tableView else { return }
        switch changes {
        case .initial:
          // Results are now populated and can be accessed without blocking the UI
          tableView.reloadData()
        case .update(_, let deletions, let insertions, let modifications):
          self?.itemsList = Array(try! Realm().objects(Items.self).sorted(byKeyPath: "id", ascending: false))
          // Query results have changed, so apply them to the UITableView
          tableView.beginUpdates()
          // Always apply updates in the following order: deletions, insertions, then modifications.
          // Handling insertions before deletions may result in unexpected behavior.
          tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                               with: .automatic)
          tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                               with: .automatic)
          tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                               with: .automatic)
          tableView.endUpdates()
        case .error(let error):
          // An error occurred while opening the Realm file on the background worker thread
          fatalError("\(error)")
        }
      }
    }
  
  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "sellerCell", for: indexPath) as! SellerTableViewCell
    
    let row = itemsList[indexPath.row]
    
    cell.itemName.text = row.title
    cell.itemDescription.text = row.desc
    cell.itemPrice.text = row.price
    

    let url = URL(string: row.img)
    if let url = url {
      let data = try? Data(contentsOf: url)
      if let data = data {
        cell.itemImage.image = UIImage(data: data)
      }  
    }
    
    
    return cell
  }
  
  deinit {
    notificationToken?.invalidate()
  }
}
