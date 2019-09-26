//
//  LoginViewController.swift
//  marketplace
//
//  Created by Gigarthan Vijayakumaran on 9/22/19.
//  Copyright © 2019 Gigarthan Vijayakumaran. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Photos

enum UserRole {
  case BUYER
  case SELLER
}

class LoginViewController: UIViewController {
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var buyerSellerButton: UISegmentedControl!
  
  var userRole: UserRole = .BUYER
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
  func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func isFieldsFilled() -> Bool {
    return ((emailField.text?.isEmpty == false) && (passwordField.text?.isEmpty == false))
  }
  
  func loginUser(email: String, pass: String) {
    let url = "https://reqres.in/api/login"
    let formData: [String: Any] = [
      "email" : email,
      "password": pass
    ]
    
    Alamofire.request(url, method: .post, parameters: formData, encoding: JSONEncoding.default, headers: nil).validate().responseJSON {
      response in
      
      switch response.result {
      case .success:
//        self.showAlert(title: "LoggedIn", message: "Success")
          self.navigateToPage()
        
      case .failure:
        if let data = response.data {
          let responseData = try! JSON(data: data)
          var errorMessage: String?
          errorMessage = responseData["error"].stringValue
          self.showAlert(title: "Error", message: errorMessage ?? "Invalid")
        }
      }
    }
    
    
  }
  
  func registerUser(email: String, pass: String) {
    let url = "https://reqres.in/api/register"
    let formData: [String: Any] = [
      "email" : email,
      "password": pass
    ]
    
    Alamofire.request(url, method: .post, parameters: formData, encoding: JSONEncoding.default, headers: nil).validate().responseJSON {
      response in
      
      switch response.result {
      case .success:
        self.showAlert(title: "Registered", message: "Success")
        
      case .failure:
        if let data = response.data {
          let responseData = try! JSON(data: data)
          var errorMessage: String?
          errorMessage = responseData["error"].stringValue
          self.showAlert(title: "Error", message: errorMessage ?? "Invalid")
        }
        
      }
    }
    
    
  }
  
  func getUserType() -> UserRole {
    switch buyerSellerButton.selectedSegmentIndex {
    case 0:
      return .BUYER
    case 1:
      return .SELLER
    default:
      return .BUYER
    }
  }
  
  func navigateToPage() {
    let userType: UserRole = getUserType()
    switch userType {
    case .BUYER:
      performSegue(withIdentifier: "SegueToBuyer", sender: self)
    case .SELLER:
      performSegue(withIdentifier: "SegueToSeller", sender: self)
    default:
      break
    }
  }
  
  @IBAction func login(_ sender: Any) {
    if(isFieldsFilled()) {
      let email = emailField.text ?? ""
      let password = passwordField.text ?? ""
      loginUser(email: email, pass: password)
    } else {
      showAlert(title: "Invalid Credentials", message: "Email or Password fields cannot be empty!")
    }
  }
  @IBAction func register(_ sender: Any) {
    if(isFieldsFilled()) {
      let email = emailField.text ?? ""
      let password = passwordField.text ?? ""
      registerUser(email: email, pass: password)
    } else {
      showAlert(title: "Invalid Credentials", message: "Email or Password fields cannot be empty!")
    }
  }
}
