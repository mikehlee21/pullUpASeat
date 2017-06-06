//
//  MyAdsNew.swift
//  PullUpASeat
//
//  Created by Star on 2/21/17.
//  Copyright © 2017 Pull-Up-A-Seat. All rights reserved.
//

import UIKit
import Parse


class MyAdsNew: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    /* Variables */
    var classifArray = [PFObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        classifArray.removeAll()
        
        let query = PFQuery(className: CLASSIF_CLASS_NAME)
        query.whereKey(CLASSIF_USER, equalTo: PFUser.current()!)
        query.order(byDescending: CLASSIF_UPDATED_AT)
        query.findObjectsInBackground { (objects, error)-> Void in
            if error == nil {
                self.classifArray = objects!
                // Populate the TableView
                self.tableView.reloadData()
                
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
            }}

        
    }

    
    /* MARK: - TABLE VIEW DELEGATES */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classifArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAdCell", for: indexPath) as! MyAdCell
        
        // SHOW ALL YOUR ADS
        var classifClass = PFObject(className: CLASSIF_CLASS_NAME)
        classifClass = classifArray[indexPath.row]
        
        // Get image
        let imageFile = classifClass[CLASSIF_IMAGE1] as? PFFile
        imageFile?.getDataInBackground(block: { (imageData, error) -> Void in
            if error == nil {
                if let imageData = imageData {
                    cell.adImage.image = UIImage(data:imageData)
                } } })
        
        
        cell.adTitleLabel.text = "\(classifClass[CLASSIF_TITLE]!)"
        cell.adDescrLabel.text = "\(classifClass[CLASSIF_DESCRIPTION]!)"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var classifClass = PFObject(className: CLASSIF_CLASS_NAME)
        classifClass = classifArray[indexPath.row]
        
        // Open to Post Controller
        let postVC = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! Post
        postVC.postObj = classifClass
        present(postVC, animated: true, completion: nil)
        
    }

    @IBAction func onBackTabbed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
