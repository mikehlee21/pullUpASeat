//
//  SignUpSubmerchant.swift
//  PullUpASeat
//
//  Created by iphone on 04/08/16.
//  Copyright © 2016 Pull-Up-A-Seat. All rights reserved.
//

import UIKit
import Parse
class SignUpSubmerchant: UIViewController {
    var getSub_MerchantArray = [PFObject]()
    
    @IBOutlet weak var scroll_View: UIScrollView!
    
    @IBOutlet weak var user_name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var locality: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var mobile: UITextField!
    
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var region: UITextField!
    @IBOutlet weak var SSN: UITextField!
    @IBOutlet weak var accountNumber: UITextField!
    @IBOutlet weak var bank: UITextField!
    @IBOutlet weak var DOB: UITextField!
    @IBOutlet weak var routingNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SIGN UP"
        scroll_View.contentSize = CGSize(width: 300, height:1030);
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func signUp(_ sender: UIButton) {
        if (firstName.text!.isEmpty) {
            globalAlert("Please enter the first name")
        }else if  (lastName.text!.isEmpty) {
            globalAlert("Please enter the last name")
        }else  if email.text!.isEmpty {
            globalAlert("Please enter the email address")
        }else if !validate(email.text!){
            globalAlert("Please enter the valid email")
        }else if (address.text!.isEmpty){
            globalAlert("Please enter the address")
        }else if (locality.text!.isEmpty){
            globalAlert("Please enter the locality")
        }else if (region.text!.isEmpty){
            globalAlert("Please enter the region")
        }else if (postalCode.text!.isEmpty){
            globalAlert("Please enter the postal code")
        }else if (mobile.text!.isEmpty){
            globalAlert("Please enter the mobile number")
        }else if (DOB.text!.isEmpty){
            globalAlert("Please enter the DOB")
        }else if (SSN.text!.isEmpty){
            globalAlert("Please enter the SSN")
        }else if (bank.text!.isEmpty){
            globalAlert("Please enter the bank name")
        }else if (accountNumber.text!.isEmpty){
            globalAlert("Please enter the account number")
        }else if (routingNumber.text!.isEmpty){
            globalAlert("Please enter the routing number")
        }
        else{
//            showHUD()
//            let add_SubMerchants = PFObject(className: "Dummy")
//            add_SubMerchants.setObject(firstName.text!, forKey: "firstName")
//            add_SubMerchants.setObject(lastName.text!, forKey: "lastName")
//            add_SubMerchants.setObject(email.text!, forKey: "email")
//            add_SubMerchants.setObject(address.text!, forKey: "address")
//            add_SubMerchants.setObject(mobile.text!, forKey: "phone")
//            add_SubMerchants.setObject(DOB.text!, forKey: "DOB")
//            add_SubMerchants.setObject(SSN.text!, forKey: "SSN")
//            add_SubMerchants.setObject(bank.text!, forKey: "bank")
//            add_SubMerchants.setObject(accountNumber.text!, forKey: "accountNumber")
//            add_SubMerchants.setObject(routingNumber.text!, forKey: "routingNumber")
//            add_SubMerchants.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
//                if error == nil { // Successful Signup
//                    self.navigationController?.popToRootViewControllerAnimated(true)
//                    self.hideHUD()
//                } else { // No signup, something went wrong
//                    self.simpleAlert("\(error!.localizedDescription)")
//                    self.hideHUD()
//                } }
//            
            
            
            showHUD()
            let userForSignUp = PFUser()
            userForSignUp.username = user_name.text
            userForSignUp.password = password.text
            userForSignUp.email = email.text
            userForSignUp.setObject(address.text!, forKey: "address")
            userForSignUp.setObject(firstName.text!, forKey: "firstName")
            userForSignUp.setObject(lastName.text!, forKey: "lastName")
            userForSignUp.setObject(mobile.text!, forKey: "phone")
            userForSignUp.setObject(DOB.text!, forKey: "DOB")
            userForSignUp.setObject(SSN.text!, forKey: "SSN")
            userForSignUp.setObject(bank.text!, forKey: "bank")
            userForSignUp.setObject(locality.text!, forKey: "locality")
            userForSignUp.setObject(region.text!, forKey: "region")
            userForSignUp.setObject(postalCode.text!, forKey: "postalCode")
            userForSignUp.setObject(accountNumber.text!, forKey: "accountNumber")
            userForSignUp.setObject(routingNumber.text!, forKey: "routingNumber")
            userForSignUp.signUpInBackground { (succeeded, error) -> Void in
                if error == nil { // Successful Signup
                    self.navigationController?.popToRootViewController(animated: true)
                    self.hideHUD()
                } else { // No signup, something went wrong
                    self.simpleAlert("\(error!.localizedDescription)")
                    self.hideHUD()
                }
            }
    }
            
            
            
            //        add_SubMerchants.findObjectsInBackgroundWithBlock { (objects, error)-> Void in
            //            if error == nil {
            //                self.favoritesArray = objects!
            //                // Show details (or reload a TableView)
            //                self.tableView.reloadData()
            //
            //            } else {
            //                self.simpleAlert("\(error!.localizedDescription)")
            //            }}
        }
        
        func validate(_ YourEMailAddress: String) -> Bool {
            let REGEX: String
            REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
        }
        
        @IBAction func TOS(_ sender: UIButton) {
            //        let touVC = self.storyboard?.instantiateViewControllerWithIdentifier("TermsOfUse") as! TermsOfUse
            //        presentViewController(touVC, animated: true, completion: nil)
            
            let query = PFQuery(className: "subMerchants")
            query.findObjectsInBackground { (objects, error)-> Void in
                if error == nil {
                    self.getSub_MerchantArray = objects!
                    // Show details (or reload a TableView)
                } else {
                    self.simpleAlert("\(error!.localizedDescription)")
                }}
        }
        
        
        func globalAlert(_ msg: String) {
            let alert = UIAlertController(title:"Pull Up A Seat", message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        //    if validateEmail("test@google.com") {
        //    }
        
        /*
         // MARK: - Navigation
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
}






