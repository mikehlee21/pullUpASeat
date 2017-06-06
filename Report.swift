//
//  Report.swift
//  PullUpASeat
//
//  Created by Camille Baker on 7/19/16.
//  Copyright © 2016 FV iMAGINATION. All rights reserved.
//

import Foundation
import UIKit
import Parse


class reportCell: UITableViewCell {
    /* Views */
//    @IBOutlet var adImage: UIImageView!
    @IBOutlet var adTitleLabel: UILabel!
//    @IBOutlet var adDescrLabel: UILabel!
}



class Report: UIViewController,
    UIAlertViewDelegate,
    UIScrollViewDelegate,
    UITextFieldDelegate
{
    let  swiftBlogs = ["Ray Wenderlich", "NSHipster", "iOS Developer Tips", "Jameson Quave", "Natasha The Robot"] ;
    var searchedAdsArray = [PFObject]()
    @IBOutlet   var tableView1: UITableView!  //<<-- TableView Outlet

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        //tableView1.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reportCell")
        //tableView1.delegate = self
        //tableView1.dataSource = self
//        self.addGroup.delegate = self
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
    }

    @IBAction func showPop(_ sender: AnyObject) {
         simpleAlert("thank you! we will resolve issue shortly")
//        let button = sender as! UIButton
//        
//        if PFUser.currentUser() != nil {
//            var classifClass = PFObject(className: CLASSIF_CLASS_NAME)
//            classifClass = searchedAdsArray[button.tag]
//            let favClass = PFObject(className: FAV_CLASS_NAME)
//            
//            // ADD THIS AD TO FAVORITES
//            favClass[FAV_USERNAME] = PFUser.currentUser()?.username!
//            favClass[FAV_AD_POINTER] = classifClass
//            
//            // Saving block
//            favClass.saveInBackgroundWithBlock { (success, error) -> Void in
//                if error == nil {
//                    self.simpleAlert("This Ad has been added to your Favorites!")
//                } else {
//                    self.simpleAlert("\(error!.localizedDescription)")
//                }}
//            
//            
//            
//            // You must login to add Favorites
//        } else { simpleAlert("You have to login/signup to favorite ads!") }
        
        
    }
    

//     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5;
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reportCell", forIndexPath: indexPath) as! reportCell
//        
//        cell.adTitleLabel.text = "mine kdf"
//        
//        // SHOW ALL YOUR ADS
////        var classifClass = PFObject(className: CLASSIF_CLASS_NAME)
////        classifClass = classifArray[indexPath.row]
////        
////        // Get image
////        let imageFile = classifClass[CLASSIF_IMAGE1] as? PFFile
////        imageFile?.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
////            if error == nil {
////                if let imageData = imageData {
////                    cell.adImage.image = UIImage(data:imageData)
////                } } })
////        
////        
////        cell.adTitleLabel.text = "\(classifClass[CLASSIF_TITLE]!)"
////        cell.adDescrLabel.text = "\(classifClass[CLASSIF_DESCRIPTION]!)"
//        
//        
//        return cell
//    }
//    
//     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
////        var classifClass = PFObject(className: CLASSIF_CLASS_NAME)
////        classifClass = classifArray[indexPath.row]
//        
////        // Open to Post Controller
////        let postVC = self.storyboard?.instantiateViewControllerWithIdentifier("Post") as! Post
////        postVC.postObj = classifClass
////        presentViewController(postVC, animated: true, completion: nil)
//        
//    }

    
}


