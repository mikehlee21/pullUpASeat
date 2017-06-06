/* =======================

 - PullUpASeat -
 
 made by Camille Baker ©2016

==========================*/

import UIKit
import Parse
import GoogleMobileAds

var searchedAdsArray = [PFObject]()



class BrowseAds: UITableViewController,
GADInterstitialDelegate {
    
    /* Variables */
    var callTAG = 0
    
    var adMobInterstitial: GADInterstitial!

    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        
        adMobInterstitial = GADInterstitial(adUnitID: ADMOB_UNIT_ID)
        let request = GADRequest()
        request.testDevices = ["2077ef9a63d2b398840261c8221a0c9b"]
        adMobInterstitial.load(request)
        adMobInterstitial.delegate = self
        
    }
    
override func viewDidLoad() {
        super.viewDidLoad()

    self.title = " Browse Ads"
    
    adMobInterstitial = GADInterstitial(adUnitID: ADMOB_UNIT_ID)
    let request = GADRequest()
    request.testDevices = ["2077ef9a63d2b398840261c8221a0c9b"]
    adMobInterstitial.load(request)
    adMobInterstitial.delegate = self
    
}


 
// MARK: - TABLEVIEW DELEGATES
override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchedAdsArray.count
}
    
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdCell", for: indexPath) as! AdCell
    var classifClass = PFObject(className: CLASSIF_CLASS_NAME)
    classifClass = searchedAdsArray[indexPath.row] 
    
    cell.adTitleLabel.text = "\(classifClass[CLASSIF_TITLE]!)"
    cell.adDescrLabel.text = "\(classifClass[CLASSIF_DESCRIPTION]!)"
    cell.addToFavOutlet.tag = (indexPath as NSIndexPath).row
    //cell.addToFavOutlet.addTarget(self, action: , for: UI)
   // cell.addToFavOutlet.addTarget(self, action: Selector(("addToFavButt:")), for: UIControlEvents.touchUpInside)

    // Get image
    let imageFile = classifClass[CLASSIF_IMAGE1] as? PFFile
    imageFile?.getDataInBackground (block: { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                cell.adImage.image = UIImage(data:imageData)
    } } })

    
return cell
}
 
// MARK: - SELECTED AN AD -> SHOW IT
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var classifClass = PFObject(className: CLASSIF_CLASS_NAME)
    classifClass = searchedAdsArray[indexPath.row]
    
    let showAdVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowSingleAdVC") as! ShowSingleAdVC
    // Pass the Ad Object to the Controller
    showAdVC.singleAdObj = classifClass
    self.navigationController?.pushViewController(showAdVC, animated: true)
        
    }
    
    
    // MARK: - ADD AD TO FAVORITES BUTTON
   @IBAction func addToFavButt(_ sender: AnyObject) {
        let button = sender as! UIButton
        
        // Get this ad
        var adObj = PFObject(className: CLASSIF_CLASS_NAME)
        adObj = searchedAdsArray[button.tag]
        
        
        if PFUser.current() != nil {
            
            // CHECK IF YOU'VE FAVORITED ALREADY THIS AD
            let query = PFQuery(className: FAV_CLASS_NAME)
            query.whereKey(FAV_USER_POINTER, equalTo: PFUser.current()!)
            query.whereKey(FAV_AD_POINTER, equalTo: adObj)
            query.findObjectsInBackground { (objects, error)-> Void in
                if error == nil {
                    if objects?.count !=  0 {
                        self.simpleAlert("You've already added this ad to your Favorites!")
                        
                        // ADD THIS AD TO YOUR FAVORITES
                    } else {
                        let favClass = PFObject(className: FAV_CLASS_NAME)
                        favClass[FAV_USERNAME] = PFUser.current()?.username!
                        favClass[FAV_USER_POINTER] = PFUser.current()!
                        favClass[FAV_AD_POINTER] = adObj
                        
                        // Saving block
                        favClass.saveInBackground { (success, error) -> Void in
                            if error == nil {
                                self.simpleAlert("This Ad has been added to your Favorites!")
                            } else {
                                self.simpleAlert("\(error!.localizedDescription)")
                            }}
                    }
                    
                } else {
                    self.simpleAlert("\(error!.localizedDescription)")
                }}
    // You must login to add Favorites
    } else { simpleAlert("You have to login/signup to favorite ads!") }
}
    

    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
