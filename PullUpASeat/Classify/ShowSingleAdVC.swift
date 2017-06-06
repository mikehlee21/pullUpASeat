/* =======================
 
 - PullUpASeat -
 
 made by Camille Baker ©2016
 
 ==========================*/


import UIKit
import MapKit
import Parse
import AudioToolbox
import MessageUI
import GoogleMobileAds
import Braintree
import BraintreeDropIn
import Alamofire
import Social
//import BTPaymentRequest


class ShowSingleAdVC: UIViewController,
    UIAlertViewDelegate,
    UIScrollViewDelegate,
    UITextFieldDelegate,
    GADInterstitialDelegate,
    MFMailComposeViewControllerDelegate,
    MKMapViewDelegate,
    BTDropInViewControllerDelegate
{
    /*!
     @brief Informs the delegate when the user has decided to cancel out of the Drop-in payment form.
     
     @discussion Drop-in handles its own error cases, so this cancelation is user initiated and
     irreversable. Upon receiving this message, you should dismiss Drop-in.
     
     @param viewController The Drop-in view controller informing its delegate of failure or cancelation.
     */
    public func drop(inViewControllerDidCancel viewController: BTDropInViewController) {
    }
    
    /*!
     @brief Informs the delegate when the user has successfully provided payment info that has been successfully tokenized.
     
     @discussion Upon receiving this message, you should dismiss Drop In.
     
     @param viewController The Drop In view controller informing its delegate of success
     @param tokenization The selected (and possibly newly created) tokenized payment information.
     */
    public func drop(_ viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {
        
    }
    
    /*!
     @brief Informs the delegate when the user has successfully provided payment info that has been successfully tokenized.
     
     /*!
     @brief Informs the delegate when the user has successfully provided payment info that has been successfully tokenized.
     
     @discussion Upon receiving this message, you should dismiss Drop In.
     
     @param viewController The Drop In view controller informing its delegate of success
     @param tokenization The selected (and possibly newly created) tokenized payment information.
     */
     public func drop(_ viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {
     <#code#>
     }
     
     @discussion Upon receiving this message, you should dismiss Drop In.
     
     @param viewController The Drop In view controller informing its delegate of success
     @param tokenization The selected (and possibly newly created) tokenized payment information.
     */
    
    
    
    /* Views */
    @IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var adTitleLabel: UILabel!
    
    @IBOutlet var imagesScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var adDescrTxt: UITextView!
    @IBOutlet var experiencetxt: UITextView!
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
    
    var dataURL = Data()
    var request = NSMutableURLRequest()
    var paymenturl:  URL!
    var url: URL!
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
    
    
    //braintree
    var braintree: BTAPIClient?
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(singleAdObj)
        showAdDetails()
        
        
        // Initialize a Report Button
        reportButt = UIButton(type: UIButtonType.custom)
        reportButt.adjustsImageWhenHighlighted = false
        reportButt.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        reportButt.setBackgroundImage(UIImage(named: "reportButt"), for: UIControlState())
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
                }}})
        
        // Get image2
        let imageFile2 = singleAdObj[CLASSIF_IMAGE2] as? PFFile
        imageFile2?.getDataInBackground (block: { (imageData, error) -> Void in
            if error == nil {
                if let imageData = imageData {
                    self.image2.image = UIImage(data:imageData)
                    self.pageControl.numberOfPages = 2
                }}})
        
        // Get image3
        let imageFile3 = singleAdObj[CLASSIF_IMAGE3] as? PFFile
        imageFile3?.getDataInBackground (block: { (imageData, error) -> Void in
            if error == nil {
                if let imageData = imageData {
                    self.image3.image = UIImage(data:imageData)
                    self.pageControl.numberOfPages = 3
                }}})
        
        
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
                if userPointer[USER_WEBSITE] != nil { self.websiteOutlet.setTitle("\(userPointer[USER_WEBSITE]!)", for: UIControlState())
                } else { self.websiteOutlet.setTitle("N/D", for: UIControlState()) }
                
                // Check if the user has provided a phone number
                if userPointer[USER_PHONE] == nil { self.phoneCallOutlet.isHidden = true
                } else { self.phoneCallOutlet.isHidden = false }
                
            } else { self.simpleAlert("\(error!.localizedDescription)")
            }}
    }
    
    
    
    @IBAction func twitterButton(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let twitterShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            showHUD()
            // twitter Title
            twitterShare.setInitialText("\(singleAdObj[CLASSIF_TITLE]!)")
            //twitter add image
            // Get image1
            let imageFile1 = singleAdObj[CLASSIF_IMAGE1] as? PFFile
            imageFile1?.getDataInBackground (block: { (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        twitterShare.add(UIImage(data:imageData))
                        self.hideHUD()
                    }}})
            
            
            // twitter URL
            
            // Get User Pointer
            let userPointer = singleAdObj[CLASSIF_USER] as! PFUser
            userPointer.fetchIfNeededInBackground { (user, error) in
                if error == nil {
                    // Check if user has provided a website
                    if userPointer[USER_WEBSITE] != nil {
                        twitterShare.add(URL(string: "\(userPointer[USER_WEBSITE]!)"))
                    }
                }
            }
            
            self.present(twitterShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func facebookButton(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            showHUD()
            // facebook Title
            fbShare.setInitialText("\(singleAdObj[CLASSIF_TITLE]!)")
            // Get image1
            let imageFile1 = singleAdObj[CLASSIF_IMAGE1] as? PFFile
            imageFile1?.getDataInBackground (block: { (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        fbShare.add(UIImage(data:imageData))
                        self.hideHUD()
                    }}})
            
            //facebook add image
            
            
            
            // facebook URL
            
            // Get User Pointer
            let userPointer = singleAdObj[CLASSIF_USER] as! PFUser
            userPointer.fetchIfNeededInBackground { (user, error) in
                if error == nil {
                    // Check if user has provided a website
                    if userPointer[USER_WEBSITE] != nil {
                        // fbShare.add(URL(string: "\(userPointer[USER_WEBSITE]!)"))
                    }
                }
            }
            
            self.present(fbShare, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    
    
    // MARK: - PHONE CALL BUTTON
    @IBAction func phoneCallButt(_ sender: AnyObject) {
        let userPointer = singleAdObj[CLASSIF_USER] as! PFUser
        userPointer.fetchIfNeededInBackground { (user, error) in
            if error == nil {
                let aURL = URL(string: "telprompt://\(userPointer[USER_PHONE]!)")!
                if UIApplication.shared.canOpenURL(aURL) {
                    UIApplication.shared.openURL(aURL)
                } else {
                    self.simpleAlert("This device can't make phone calls")
                }
                
            } else { self.simpleAlert("\(error!.localizedDescription)")
            }}
    }
    
    //   "http://77.104.146.199/~pullupas/index.php"
    //    http://202.164.59.107/braintree/paramnoor/index.php
    
    
    // MARK: - BUY BUTTON
    @IBAction func buyButt(_ sender: AnyObject) {
        //create and retain a `Braintree` instance with the client token.
        let clientTokenURL = URL(string: "http://202.164.59.107/braintree/paramnoor/index.php")!
        let clientTokenRequest = NSMutableURLRequest(url: clientTokenURL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: clientTokenRequest as URLRequest) { (data, response, error) -> Void in
            // TODO: Handle errors
            let clientToken = String(data: data!, encoding: String.Encoding.utf8)
            
            // As an example, you may wish to present Drop-in at this point.
            // Continue to the next section to learn more...
            self.showDropIn(clientTokenOrTokenizationKey: clientToken!)
            
            
            
            }.resume()
        // present our Drop-in UI at this point.
        // Create a BTDropInViewController
      //  self.braintree = BTAPIClient.init(authorization: clientTokenRequest)
      
         }
    
    
    
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                
                let dropInViewController = BTDropInViewController.init(apiClient: self.braintree!)
                dropInViewController.delegate = self
                
                let paymentRequest = BTPaymentRequest()
                paymentRequest.summaryTitle = self.adTitleLabel.text
                paymentRequest.summaryDescription = self.adDescrTxt.text
                paymentRequest.displayAmount = self.priceLabel.text!
                //
                dropInViewController.paymentRequest = paymentRequest
                
                // This is where you might want to customize your Drop-in. (See below.)
                dropInViewController.view.tintColor = UIColor(red: 255/255.0, green: 136/255.0, blue: 51/255.0, alpha: 1.0)
                
                // The way you present your BTDropInViewController instance is up to you.
                // In this example, we wrap it in a new, modally presented navigation controller:
                dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.userDidCancelPayment))
                
                
                let navigationController = UINavigationController(rootViewController: dropInViewController)
                self.present(navigationController, animated: true, completion: nil)
                

                
                
                
                
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    
    func userDidCancelPayment() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //http://202.164.59.107/braintree/paramnoor/payment_method.php
    // http://77.104.146.199/~pullupas/payment-methods.php
    
    
    var paymentURL = URL(string:"http://202.164.59.107/braintree/paramnoor/payment_method.php")!
    
    func postNonceToServer(_ paymentMethodNonce: String, amount: Float) {
        var request = NSMutableURLRequest(url: paymenturl)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)&amount=\(amount)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        _ = URLSession.shared.dataTask(with: request as URLRequest) { _,_,_ in }
        
        
        func userDidCancelPayment() {
            self.dismiss(animated: true, completion: nil)
        }
        
        func drop(_ viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {
            let amount = self.priceLabel.text!.replacingOccurrences(of: "$", with:"") as String
            //  let amount = "20"
            postNonceToServer(paymentMethodNonce.nonce,amount: (NumberFormatter().number(from: amount)?.floatValue)!)
            // Send payment method nonce to your server
            print("NONCE: \(paymentMethodNonce.nonce) , amount:\((NumberFormatter().number(from: amount)?.floatValue)!)")
            
            
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarViewController")
            //let storyboard : UIStoryboard = UIStoryboard.init(name: "main", bundle: nil)
            let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            window.rootViewController = homeVC
            window.makeKeyAndVisible()
        }
        
        func drop(inViewControllerDidCancel viewController: BTDropInViewController) {
            dismiss(animated: true, completion: nil)
        }
        
        
        // MARK: - REPORT AD BUTTON
        
        
        
        // MARK: - TAP ON IMAGE TO CLOSE PREVIEW
        func tapToClosePreview(_ sender: UITapGestureRecognizer) {
            hideImagePrevView()
        }
        
        // MARK: - SHOW/HIDE PREVIEW IMAGE VIEW
        func showImagePrevView() {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.imagePreviewView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                self.instructionsLabel.isHidden = false
                self.imgPrev.frame = self.imagePreviewView.frame
            }, completion: { (finished: Bool) in  })
        }
        func hideImagePrevView() {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.imagePreviewView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                self.instructionsLabel.isHidden = true
                self.imgPrev.frame = self.imagePreviewView.frame
            }, completion: { (finished: Bool) in  })
        }
        
        // MARK: - SCROLLVIW DELEGATE FOR ZOOMING IMAGE
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imgPrev
        }
        
        
        
        //  ($user_id='',$name='',$email='',$dob='',$streetaddress='',$locality='',$region='',$postalcode='',$accountNumber='',$routingNumber='')
        
        
        func sendMerchantDetail() -> Void{
            //
            //            let jsonDictionary:[String:String] = ["accountNumber":(singleAdObj.valueForKey("accountNumber") as?String)!,
            //                     "routingNumber": (singleAdObj.valueForKey("routingNumber") as?String)!,
            //                     "firstName": (singleAdObj.valueForKey("firstName") as?String)!,
            //                     "lastName": (singleAdObj.valueForKey("lastName") as?String)!,
            //                     "email": "inderpal@jarvicstech.com",
            //                     "phone": (singleAdObj.valueForKey("phone") as?String)!,
            //                     "dateOfBirth":"2012-10-09",
            //                     "ssn": (singleAdObj.valueForKey("SSN") as?String)!,
            //                     "streetAddress": "111 Main St",
            //                     "locality": "Chicago",
            //                     "region":"IL",
            //                     "postalCode": "60622",
            //                     ]
            //        Alamofire.request(.POST, "http://202.164.59.107/braintree/paramnoor/merchant_payment.php", parameters: jsonDictionary) .response { request, response, data, error in
            //            print(request)
            //            print(response)
            //            print(error)
            //            print(data)
            //        }
            //        let headers = [
            //            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            //            "Accept": "application/json"
            //        ]
            //
            //        Alamofire.request(.GET, "https://httpbin.org/get", headers: headers)
            //            .responseJSON { response in
            //                debugPrint(response)
            //        }
        }
        let URL = Foundation.URL(string: "http://202.164.59.107/braintree/paramnoor/merchant_payment.php")!
        let mutableURLRequest = NSMutableURLRequest(url: URL)
        mutableURLRequest.httpMethod = "POST"
        
        //     let parameters = ["api_key": "______", "email_details": ["fromname": "______", "subject": "this is test email subject", "from": "support@apple.com", "content": "<p> hi, this is a test email sent via Pepipost JSON API.</p>"], "recipients": ["_________"]]
        
        let parameters:[String:String] = ["accountNumber":(singleAdObj.value(forKey: "accountNumber") as?String)!,
                                          "routingNumber": (singleAdObj.value(forKey: "routingNumber") as?String)!,
                                          "firstName": (singleAdObj.value(forKey: "firstName") as?String)!,
                                          "lastName": (singleAdObj.value(forKey: "lastName") as?String)!,
                                          "email": "inderpal@jarvicstech.com",
                                          "phone": (singleAdObj.value(forKey: "phone") as?String)!,
                                          "dateOfBirth":"2012-10-09",
                                          "ssn": (singleAdObj.value(forKey: "SSN") as?String)!,
                                          "streetAddress": "111 Main St",
                                          "locality": "Chicago",
                                          "region":"IL",
                                          "postalCode": "60622",
                                          ]
        
        do {
            mutableURLRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch {
            // No-op
        }
        
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(mutableURLRequest as! URLRequestConvertible)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
        
        
    }
}
