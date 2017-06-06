/* =======================

 - PullUpASeat -
 
 made by Camille Baker ©2016


==========================*/


import UIKit
import Parse
import GoogleMobileAds
import AudioToolbox
import DropDown

class Home: UIViewController,
UITextFieldDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
GADInterstitialDelegate
{

    /* Views */
    @IBOutlet var searchOutlet: UIButton!
    @IBOutlet var termsOfUseOutlet: UIButton!
    @IBOutlet weak var avaTxt: UITextField!
    @IBOutlet weak var expTxt: UITextField!
    @IBOutlet weak var dropDownViewAva: UIView!
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var dropDownViewExp: UIView!
    @IBOutlet var fieldsView: UIView!
    @IBOutlet var keywordsTxt: UITextField!
    @IBOutlet var categoryTxt: UITextField!
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet var categoryContainer: UIView!
    @IBOutlet var categoryPickerView: UIPickerView!
    
    @IBOutlet var categoriesScrollView: UIScrollView!
    
    @IBOutlet weak var viewLocation: UIView!
    var adMobInterstitial: GADInterstitial!

    @IBOutlet weak var dropDownView: UIView!
    
    var dropDownLoc: DropDown?
    var dropDownExp: DropDown?
    var dropDownAva: DropDown?
    /* Variables */
    var classifArray = [PFObject]()
    var catButton = UIButton()
    
    
    
    
    

override func viewWillAppear(_ animated: Bool) {
    searchedAdsArray.removeAll()
}
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    self.navigationController?.isNavigationBarHidden = true
    
    searchText.delegate = self
    
    // Init AdMob interstitial
    let delayTime = DispatchTime.now() + Double(Int64(36 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    adMobInterstitial = GADInterstitial(adUnitID: ADMOB_UNIT_ID)
    adMobInterstitial.load(GADRequest())
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        self.showInterstitial()
    }
    
    
    // Round views corners
    searchOutlet.layer.cornerRadius = 8
    searchOutlet.layer.shadowColor = UIColor.black.cgColor
    searchOutlet.layer.shadowOffset = CGSize(width: 0, height: 1.5)
    searchOutlet.layer.shadowOpacity = 0.8

    //termsOfUseOutlet.layer.cornerRadius = 8
    
    
    // Put fieldsView in the center of the screen
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        fieldsView.center = CGPoint(x: view.frame.size.width/2, y: 300 )
    }
    
    // Hide the Categ. PickerView
    categoryContainer.frame.origin.y = view.frame.size.height
    view.bringSubview(toFront: categoryContainer)
    
    //init location drop down
    dropDownLoc = DropDown()
    dropDownLoc?.anchorView = self.dropDownView
    dropDownLoc?.dataSource = ["Orlando, Florida", "Springfield, Mo", "Miami, Florida"]
    let gesture1 = UITapGestureRecognizer(target: self, action: #selector(Home.LocAction(_:)))
    dropDownView.addGestureRecognizer(gesture1)
    
    //init location drop down
    dropDownExp = DropDown()
    dropDownExp?.anchorView = self.dropDownViewExp
    dropDownExp?.dataSource = ["Social Dining", "Takeout"]
    let gesture2 = UITapGestureRecognizer(target: self, action: #selector(Home.ExpAction(_:)))
    dropDownViewExp.addGestureRecognizer(gesture2)
    
    //init location drop down
    dropDownAva = DropDown()
    dropDownAva?.anchorView = self.dropDownViewAva
    dropDownAva?.dataSource = ["Immediate", "Preorder"]
    let gesture3 = UITapGestureRecognizer(target: self, action: #selector(Home.AvaAction(_:)))
    dropDownViewAva.addGestureRecognizer(gesture3)
    
}

    func LocAction(_ sender:UITapGestureRecognizer){
        self.dropDownLoc?.show()
        
        self.dropDownLoc?.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.locationTxt.text = item
        }
    }
    
    func AvaAction(_ sender:UITapGestureRecognizer){
        self.dropDownAva?.show()
        
        self.dropDownAva?.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.avaTxt.text = item
        }
    }
    
    func ExpAction(_ sender:UITapGestureRecognizer){
        self.dropDownExp?.show()
        
        self.dropDownExp?.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.expTxt.text = item
        }
    }
    
// MARK: - SETUP CATEGORIES SCROLL VIEW
func setupCategoriesScrollView() {
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 0
        let buttonWidth:CGFloat = 90
        let buttonHeight: CGFloat = 90
        let gapBetweenButtons: CGFloat = 5
        
        var itemCount = 0
     //categoriesScrollView.contentSize =  CGSizeMake(95, 2300)
    
    
        // Loop for creating buttons ========
        for i in 0..<categoriesArray.count {
            itemCount = i
            
            // Create a Button
            catButton = UIButton(type: UIButtonType.custom)
            catButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            catButton.tag = itemCount
            catButton.showsTouchWhenHighlighted = true
            catButton.setTitle("\(categoriesArray[itemCount])", for: UIControlState())
            catButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 12)
            catButton.setTitleColor(UIColor.white, for: UIControlState())
            catButton.setBackgroundImage(UIImage(named: "\(categoriesArray[itemCount])"), for: UIControlState())
            catButton.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom
            catButton.layer.cornerRadius = 5
            catButton.clipsToBounds = true
            catButton.addTarget(self, action: #selector(catButtTapped(_:)), for: UIControlEvents.touchUpInside)
            
            // Add Buttons & Labels based on xCood
            xCoord +=  buttonWidth + gapBetweenButtons
            categoriesScrollView.addSubview(catButton)
        } // END LOOP ================================
    
        // Place Buttons into the ScrollView =====
        categoriesScrollView.contentSize = CGSize( width: (buttonWidth + 5) * CGFloat( itemCount + 1), height: yCoord)
       }

    //Use this instead of viewdidload since viewdidLoad does not always work
    override func viewDidLayoutSubviews() {
                setupCategoriesScrollView()
    }
    
    
// MARK: - ADMOB INTESRSTITIAL
func showInterstitial() {
    // Show AdMob interstitial
    if adMobInterstitial.isReady {
        adMobInterstitial.present(fromRootViewController: self)
        print("present Interstitial")
    }
}
    
    
    
    
// MARK: - CATEGORY BUTTON TAPPED
func catButtTapped(_ sender: UIButton) {
    let button = sender as UIButton
    let categoryStr = "\(button.title(for: UIControlState())!)"
    
    searchedAdsArray.removeAll()
    showHUD()
    
    let query = PFQuery(className: CLASSIF_CLASS_NAME)
    query.whereKey(CLASSIF_CATEGORY, equalTo: categoryStr)
    query.order(byAscending: CLASSIF_UPDATED_AT)
    query.limit = 30
    query.findObjectsInBackground { (objects, error)-> Void in
        if error == nil {
            searchedAdsArray = objects!
            
            // Go to Browse Ads VC
            let baVC = self.storyboard?.instantiateViewController(withIdentifier: "BrowseAds") as! BrowseAds
            self.navigationController?.pushViewController(baVC, animated: true)
            self.hideHUD()
            
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
}
    
    
    
    
// MARK: - SEARCH BUTTON
@IBAction func searchButt(_ sender: AnyObject) {
    searchedAdsArray.removeAll()

    let keywordsArray = keywordsTxt.text!.components(separatedBy: " ") as NSArray
    showHUD()
    
    let query = PFQuery(className: CLASSIF_CLASS_NAME)
    query.whereKey(CLASSIF_DESCRIPTION_LOWERCASE, contains: "\((keywordsArray[0] as AnyObject).lowercased)")
    query.whereKey(CLASSIF_CATEGORY, equalTo: categoryTxt.text!)
    query.whereKey(CLASSIF_AVAILABILITY, equalTo: avaTxt.text!)
    query.whereKey(CLASSIF_EXPERIENCE, equalTo: expTxt.text!)
    query.whereKey(CLASSIF_ADDRESS_STRING, contains: locationTxt.text!.lowercased())
    query.order(byAscending: CLASSIF_UPDATED_AT)
    query.limit = 30
    
    query.findObjectsInBackground { (objects, error)-> Void in
        if error == nil {
            searchedAdsArray = objects!
            
            if searchedAdsArray.count > 0 {
            // Go to Browse Ads VC
            let baVC = self.storyboard?.instantiateViewController(withIdentifier: "BrowseAds") as! BrowseAds
            self.navigationController?.pushViewController(baVC, animated: true)
            self.hideHUD()
            
            } else {
                self.simpleAlert("Nothing found with your search keywords, try different keywords, location or category")
                self.hideHUD()
            }
            
            
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
    

}

    
    
    
// MARK: -  TEXTFIELD DELEGATE
func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == categoryTxt {
        showCatPickerView()
        keywordsTxt.resignFirstResponder()
        categoryTxt.resignFirstResponder()
    }
        
return true
}
    
func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == categoryTxt {
        showCatPickerView()
        keywordsTxt.resignFirstResponder()
        categoryTxt.resignFirstResponder()
    }
}
    
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == keywordsTxt {  categoryTxt.becomeFirstResponder()  }

    if textField == searchText {
        textField.resignFirstResponder()
    }
return true
}
    
    
    
    
// MARK: - PICKERVIEW DELEGATES
func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1;
}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return categoriesArray.count
}
    
func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
    return categoriesArray[row]
}

func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    categoryTxt.text = "\(categoriesArray[row])"
}

    
// PICKERVIEW DONE BUTTON
@IBAction func doneButt(_ sender: AnyObject) {
    hideCatPickerView()
}

    
    @IBAction func onPostAD(_ sender: Any) {
        // USER IS NOT LOGGED IN
        if PFUser.current() == nil {
            simpleAlert("You must first login/signup to Post an Ad")
            
            // USER IS LOGGED IN -> CAN POST A NEW AD
        } else {
            let postVC = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! Post
            present(postVC, animated: true, completion: nil)
        }
    }
    
    
    
// MARK: - POST A NEW AD BUTTON
@IBAction func postAdButt(_ sender: AnyObject) {
    // USER IS NOT LOGGED IN
    if PFUser.current() == nil {
        simpleAlert("You must first login/signup to Post an Ad")
        
    // USER IS LOGGED IN -> CAN POST A NEW AD
    } else {
        let postVC = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! Post
        present(postVC, animated: true, completion: nil)
    }
}

    
    
    
// MARK: - DISMISS KEYBOARD ON TAP
@IBAction func dismissKeyboardOnTap(_ sender: UITapGestureRecognizer) {
    keywordsTxt.resignFirstResponder()
    categoryTxt.resignFirstResponder()
    hideCatPickerView()
}
    
    
    
// MARK: - SHOW/HIDE CATEGORY PICKERVIEW
func showCatPickerView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.categoryContainer.frame.origin.y = self.view.frame.size.height - self.categoryContainer.frame.size.height-44
    }, completion: { (finished: Bool) in  });
}
func hideCatPickerView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.categoryContainer.frame.origin.y = self.view.frame.size.height
    }, completion: { (finished: Bool) in  });
}
    
    
    
    
// MARK: - SHOW TERMS OF USE
@IBAction func termsOfUseButt(_ sender: AnyObject) {
    let touVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsOfUse") as! TermsOfUse
    present(touVC, animated: true, completion: nil)
}
    
    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
}
