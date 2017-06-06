/* =======================

 - PullUpASeat -
 
 made by Camille Baker ©2016

==========================*/


import UIKit
import Parse
import MapKit
import GoogleMobileAds
import AudioToolbox
import MessageUI
import Social



class ShowSingleAd: UIViewController,
UIAlertViewDelegate,
UIScrollViewDelegate,
UITextFieldDelegate,
GADInterstitialDelegate,
MFMailComposeViewControllerDelegate,
MKMapViewDelegate
{

    /* Views */
    @IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var adTitleLabel: UILabel!
    
    @IBOutlet var imagesScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var experiencetxt: UITextView!
    @IBOutlet var adDescrTxt: UITextView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet weak var websiteOutlet: UIButton!
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var messageTxt: UITextView!
    @IBOutlet var nameTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var phoneTxt: UITextField!
    
    @IBOutlet var sendOutlet: UIButton!
    @IBOutlet weak var phoneCallOutlet: UIButton!
    var reportButt = UIButton()

    // For image Preview
    @IBOutlet var imageButtons: [UIButton]!
    @IBOutlet var imagePreviewView: UIView!
    @IBOutlet var imgScrollView: UIScrollView!
    @IBOutlet var imgPrev: UIImageView!
    @IBOutlet weak var instructionsLabel: UILabel!

    
    var adMobInterstitial: GADInterstitial!
    
    
    
    /* Variables */
    var singleAdObj = PFObject(className: CLASSIF_CLASS_NAME)
    
    var receiverEmail = ""
    var postTitle = ""
    
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinView:MKPinAnnotationView!
    var region: MKCoordinateRegion!
    

    
    
    
    

    
override func viewDidLoad() {
        super.viewDidLoad()
    
    showAdDetails()
    
    
    // Initialize a Report Button
    reportButt = UIButton(type: UIButtonType.custom)
    reportButt.adjustsImageWhenHighlighted = false
    reportButt.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
    reportButt.setBackgroundImage(UIImage(named: "reportButt"), for: UIControlState())
    reportButt.addTarget(self, action: #selector(reportButton(_:)), for: UIControlEvents.touchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: reportButt)
    
    
    // Init AdMob interstitial
    let delayTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    adMobInterstitial = GADInterstitial(adUnitID: ADMOB_UNIT_ID)
    adMobInterstitial.load(GADRequest())
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        self.showInterstitial()
    }
    
    
    // Reset variables for Reply
    receiverEmail = ""
    postTitle = ""
    
    
    // Setup container ScrollView
    containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: 1500)
    
    
    // Setup images ScrollView and their buttons
    imagesScrollView.contentSize = CGSize(width: imagesScrollView.frame.size.width*3, height: imagesScrollView.frame.size.height)
    image1.frame.origin.x = 0
    image2.frame.origin.x = imagesScrollView.frame.size.width
    image3.frame.origin.x = imagesScrollView.frame.size.width*2
    
    imageButtons[0].frame.origin.x = 0
    imageButtons[1].frame.origin.x = imagesScrollView.frame.size.width
    imageButtons[2].frame.origin.x = imagesScrollView.frame.size.width*2

    imagePreviewView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    instructionsLabel.isHidden = true
    
    // Round views corners
    sendOutlet.layer.cornerRadius = 8
    phoneCallOutlet.layer.cornerRadius = 8

}
    
    
    
    
    
// MARK: - SHOW AD DETAILS
func showAdDetails() {
    
    // Get Ad Title
    adTitleLabel.text = "\(singleAdObj[CLASSIF_TITLE]!)"
    self.title = "\(singleAdObj[CLASSIF_TITLE]!)"
    
     // Get image1
    let imageFile1 = singleAdObj[CLASSIF_IMAGE1] as? PFFile
    imageFile1?.getDataInBackground (block: { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                self.image1.image = UIImage(data:imageData)
                self.pageControl.numberOfPages = 1
    } } })
    
    // Get image2
    let imageFile2 = singleAdObj[CLASSIF_IMAGE2] as? PFFile
    imageFile2?.getDataInBackground (block: { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                self.image2.image = UIImage(data:imageData)
                self.pageControl.numberOfPages = 2
    } } })
    
    // Get image3
    let imageFile3 = singleAdObj[CLASSIF_IMAGE3] as? PFFile
    imageFile3?.getDataInBackground (block: { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                self.image3.image = UIImage(data:imageData)
                self.pageControl.numberOfPages = 3
    } } })
    
    // Get Ad Price
    priceLabel.text = "\(singleAdObj[CLASSIF_PRICE]!)"
    
    // Get Ad Description
    adDescrTxt.text = "\(singleAdObj[CLASSIF_DESCRIPTION]!)"
    
    
    
    // Get Ad Address
    addressLabel.text = "\(singleAdObj[CLASSIF_ADDRESS_STRING]!)"
    addPinOnMap(addressLabel.text!)

    
    // Get User Pointer
    let userPointer = singleAdObj[CLASSIF_USER] as! PFUser
    userPointer.fetchIfNeededInBackground { (user, error) in
        if error == nil {
            self.usernameLabel.text = userPointer.username!
    
            // Check if user has provided a website
            if userPointer[USER_WEBSITE] != nil { self.websiteOutlet.setTitle("\(userPointer[USER_WEBSITE]!)", for: .normal)
            } else { self.websiteOutlet.setTitle("N/D", for: .normal) }
    
            // Check if the user has provided a phone number
            if userPointer[USER_PHONE] == nil { self.phoneCallOutlet.isHidden = true
            } else { self.phoneCallOutlet.isHidden = false }
            
        } else { self.simpleAlert("\(error!.localizedDescription)")
    }}
}
    
    
    
// OPEN SELLER'S WEBSITE (IF IT EXISTS)
@IBAction func websiteButt(_ sender: AnyObject) {
    let butt = sender as! UIButton
    let webStr = "\(butt.titleLabel!.text!)"
    if webStr != "N/D" {
        let webURL = URL(string: webStr)
        UIApplication.shared.openURL(webURL!)
    }
}
 
    
    
    
// MARK: - ADMOB INTERSTITIAL DELEGATES
func showInterstitial() {
    // Show AdMob interstitial
    if adMobInterstitial.isReady {
        adMobInterstitial.present(fromRootViewController: self)
        print("present Interstitial")
    }
}

// TWITTER SHARE BUTTON

    
    
//MARK: - ADD A PIN ON THE MAP
func addPinOnMap(_ address: String) {
    mapView.delegate = self
    
    if mapView.annotations.count != 0 {
            annotation = mapView.annotations[0] 
            mapView.removeAnnotation(annotation)
    }
        // Make a search on the Map
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = address
        localSearch = MKLocalSearch(request: localSearchRequest)
            
        localSearch.start { (localSearchResponse, error) -> Void in
            // Place not found or GPS not available
            if localSearchResponse == nil  {
                let alert = UIAlertView(title: APP_NAME,
                message: "Place not found, or GPS not available",
                delegate: nil,
                cancelButtonTitle: "Try again" )
                alert.show()
            }
                
            // Add PointAnnonation text and a Pin to the Map
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = self.adTitleLabel.text
            self.pointAnnotation.subtitle = self.addressLabel.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D( latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:localSearchResponse!.boundingRegion.center.longitude)
                
            self.pinView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
                self.mapView.addAnnotation(self.pinView.annotation!)
                
            // Zoom the Map to the location
            self.region = MKCoordinateRegionMakeWithDistance(self.pointAnnotation.coordinate, 1000, 1000);
            self.mapView.setRegion(self.region, animated: true)
            self.mapView.regionThatFits(self.region)
            self.mapView.reloadInputViews()
        }
}

 
    
// MARK: - ADD RIGHT CALLOUT TO OPEN IN IOS MAPS APP
func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Handle custom annotations.
        if annotation.isKind(of: MKPointAnnotation.self) {
            
            // Try to dequeue an existing pin view first.
            let reuseID = "CustomPinAnnotationView"
            var annotView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
            
            if annotView == nil {
                annotView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
                annotView!.canShowCallout = true
                
                // Custom Pin image
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
                imageView.image =  UIImage(named: "locationButt")
                imageView.center = annotView!.center
                imageView.contentMode = UIViewContentMode.scaleAspectFill
                annotView!.addSubview(imageView)
                
                // Add a RIGHT CALLOUT Accessory
                let rightButton = UIButton(type: UIButtonType.custom)
                rightButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
                rightButton.layer.cornerRadius = rightButton.bounds.size.width/2
                rightButton.clipsToBounds = true
                rightButton.setImage(UIImage(named: "openInMaps"), for: UIControlState())
                annotView!.rightCalloutAccessoryView = rightButton
            }
    return annotView
    }
        
return nil
}
    
    
    
// MARK: - OPEN THE NATIVE iOS MAPS APP
func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    annotation = view.annotation
    let coordinate = annotation.coordinate
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
    let mapitem = MKMapItem(placemark: placemark)
    mapitem.name = annotation.title!
    mapitem.openInMaps(launchOptions: nil)
}
    

    
    
    
// MARK: - SCROLLVIEW DELEGATE
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // switch pageControl to current page
    let pageWidth = imagesScrollView.frame.size.width
    let page = Int(floor((imagesScrollView.contentOffset.x * 2 + pageWidth) / (pageWidth * 2)))
    pageControl.currentPage = page
}
    
    
// MARK: - TEXTFIELD DELEGATE
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == nameTxt { emailTxt.becomeFirstResponder() }
    if textField == emailTxt { phoneTxt.becomeFirstResponder() }
    if textField == phoneTxt { phoneTxt.resignFirstResponder() }
        
return true
}
    
    
    
    
// MARK: - SEND REPLY BUTTON
    @IBAction func sendReplyButt(_ sender: AnyObject) {
        let userPointer = singleAdObj[CLASSIF_USER] as! PFUser
        userPointer.fetchIfNeededInBackground { (user, error) in
            if error == nil {
                
                self.receiverEmail = userPointer.email!
                self.postTitle = self.adTitleLabel.text!
                print("\(self.receiverEmail)")
                
                if self.messageTxt.text != "" && self.emailTxt.text != ""  && self.nameTxt.text != "" {
                    
                    let strURL = "\(PATH_TO_PHP_FILE)sendReply.php?name=\(self.nameTxt.text!)&fromEmail=\(self.emailTxt.text!)&tel=\(self.phoneTxt.text!)&messageBody=\(self.messageTxt.text!)&receiverEmail=\(self.receiverEmail)&postTitle=\(self.postTitle)"
                    let reqURL = URL(string: strURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)! )!
                    let request = NSMutableURLRequest()
                    request.url = reqURL
                    request.httpMethod = "GET"
                    let connection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)
                    print("REQUEST URL: \(reqURL) - \(connection!.description)")
                    
                    self.simpleAlert("Thanks, You're reply has been sent!")
                    
                    
                    // SOME REQUIRED FIELD IS EMPTY...
                } else { self.simpleAlert("Please fill all the required fields.") }
                
                
            } else { self.simpleAlert("\(error!.localizedDescription)")
            }}
    }
    
    
 
    
    
// MARK: - PHONE CALL BUTTON
@IBAction func phoneCallButt(_ sender: AnyObject) {
    let userPointer = singleAdObj[CLASSIF_USER] as! PFUser
    userPointer.fetchIfNeededInBackground { (user, error) in
        if error == nil {
            let aURL = NSURL(string: "telprompt://\(userPointer[USER_PHONE]!)")!
            if UIApplication.shared.canOpenURL(aURL as URL) {
                UIApplication.shared.openURL(aURL as URL)
            } else {
                self.simpleAlert("This device can't make phone calls")
            }
     
        } else { self.simpleAlert("\(error!.localizedDescription)")
    }}
}
    
    
    
    
 
// MARK: - REPORT AD BUTTON
func reportButton(_ sender:UIButton) {
    let mailComposer = MFMailComposeViewController()
    mailComposer.mailComposeDelegate = self
    mailComposer.setToRecipients([MY_REPORT_EMAIL_ADDRESS])
    mailComposer.setSubject("Reporting Inappropriate Ad")
    
    mailComposer.setMessageBody("Hello,<br>I am reporting an ad with ID: <strong>\(singleAdObj.objectId!)</strong><br> and Title: <strong>\(singleAdObj[CLASSIF_TITLE]!)</strong><br>since it contains inappropriate contents and violates the Terms of Use of this App.<br><br>Please moderate this post.<br><br>Thank you very much,<br>Regards", isHTML: true)
    
    if MFMailComposeViewController.canSendMail() {
        present(mailComposer, animated: true, completion: nil)
    } else {
        simpleAlert("Your device cannot send emails. Please configure an email address into Settings -> Mail, Contacts, Calendars.")
    }
}
// Email delegate
func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        var outputMessage = ""
        switch result.rawValue {
            case MFMailComposeResult.cancelled.rawValue:  outputMessage = "Mail cancelled"
            case MFMailComposeResult.saved.rawValue:  outputMessage = "Mail saved"
            case MFMailComposeResult.sent.rawValue:  outputMessage = "Thanks for reporting this post. We will check it out asap and moderate it"
            case MFMailComposeResult.failed.rawValue:  outputMessage = "Something went wrong with sending Mail, try again later."
        default: break }
    
    simpleAlert(outputMessage)
    dismiss(animated: false, completion: nil)
}

    
 
    
    
    
    
// MARK: - SHOW IMAGE PREVIEW BUTTONS
@IBAction func showImagePreviewButt(_ sender: AnyObject) {
    let butt = sender as! UIButton
        
    var imageFile:PFFile?
        
    switch butt.tag {
        case 0: imageFile = singleAdObj[CLASSIF_IMAGE1] as? PFFile
        case 1: imageFile = singleAdObj[CLASSIF_IMAGE2] as? PFFile
        case 2: imageFile = singleAdObj[CLASSIF_IMAGE3] as? PFFile
    default:break }
        
    // Get image
    imageFile?.getDataInBackground(block: { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                self.imgPrev.image = UIImage(data:imageData)
                self.showImagePrevView()
    }}})
}
    
    
// MARK: - TAP ON IMAGE TO CLOSE PREVIEW
@IBAction func tapToClosePreview(_ sender: UITapGestureRecognizer) {
    hideImagePrevView()
}
    
    
// MARK: - SHOW/HIDE PREVIEW IMAGE VIEW
func showImagePrevView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.imagePreviewView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.instructionsLabel.isHidden = false
    }, completion: { (finished: Bool) in  })
}
func hideImagePrevView() {
    imgPrev.image = nil
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.imagePreviewView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.instructionsLabel.isHidden = true
    }, completion: { (finished: Bool) in  })
}

    
// MARK: - SCROLLVIW DELEGATE FOR ZOOMING IMAGE
func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imgPrev
}
    
//Share on Twitter
    @IBAction func tweetBtn (sender:AnyObject) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            var tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            self.present(tweetShare, animated: true, completion: nil)
            
        } else {
            
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
//Share on Facebook
    @IBAction func facebookBtn (sender:AnyObject) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.present(fbShare, animated: true, completion: nil)
            
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }



    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
