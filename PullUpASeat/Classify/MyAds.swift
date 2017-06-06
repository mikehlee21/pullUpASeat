/* =======================

 - PullUpASeat -
 
 made by Camille Baker ©2016

==========================*/

import UIKit
import Parse


class MyAds: UITableViewController {

    /* Variables */
    var classifArray = [PFObject]()
    
    
    
    
override func viewDidAppear(_ animated: Bool) {
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
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    self.title = "My Ads"
   
}

    
    
    
    
/* MARK: - TABLE VIEW DELEGATES */
override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classifArray.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var classifClass = PFObject(className: CLASSIF_CLASS_NAME)
    classifClass = classifArray[indexPath.row]
    
    // Open to Post Controller
    let postVC = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! Post
    postVC.postObj = classifClass
    present(postVC, animated: true, completion: nil)

}

    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
}
