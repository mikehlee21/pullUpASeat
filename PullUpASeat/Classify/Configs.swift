/* =======================

 - PullUpASeat -
 
 made by Camille Baker ©2016


==========================*/


import Foundation
import UIKit


// CHANGE THE RED STRING BELOW ACCORDINGLY TO THE NAME YOU'LL GIVE TO YOUR OWN VERISON OF THIS APP
var APP_NAME = "Pullupaseat"


var categoriesArray = [
    "American",
    "Spanish",
    "Bakery",
    "Breakfast",
    "International",
    "Italian",
    "BBQ",
    "Soul Food",
    "Specialities",
    "African"
    
    
    // You can add more Categories here....
]



// IMPORTANT: Change the red string below with the path where you've stored the sendReply.php file (in this case we've stored it into a directory in our website called "classify")
var PATH_TO_PHP_FILE = "http://77.104.146.199/~pullupas/mailservice/"

// IMPORTANT: You must replace the red email address below with the one you'll dedicate to Report emails from Users, in order to also agree with EULA Terms (Required by Apple)
let MY_REPORT_EMAIL_ADDRESS = "team@pullupaseatapp.com"

// IMPORTANT: Replace the red string below with your own AdMob INTERSTITIAL's Unit ID
var ADMOB_UNIT_ID = "ca-app-pub-1589840844604187/4770768158"


// HUD View
let hudView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
let indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
extension UIViewController {
    func showHUD() {
        hudView.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        hudView.backgroundColor = UIColor.darkGray
        hudView.alpha = 0.9
        hudView.layer.cornerRadius = hudView.bounds.size.width/2
        
        indicatorView.center = CGPoint(x: hudView.frame.size.width/2, y: hudView.frame.size.height/2)
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        hudView.addSubview(indicatorView)
        indicatorView.startAnimating()
        view.addSubview(hudView)
    }
    func hideHUD() { hudView.removeFromSuperview() }
    
    func simpleAlert(_ mess:String) {
        UIAlertView(title: APP_NAME, message: mess, delegate: nil, cancelButtonTitle: "OK").show()
    }
}

//ALERT



// PARSE KEYS (replace the 2 red strings below with your own keys on back4app.com)
var PARSE_APP_KEY = "6f1ZTPw0Trhnid8UJpOcmDUTEL6uJ7Y33pfUnhly"
var PARSE_CLIENT_KEY = "YnzQmEey8x4yZKyXNGXZqekWqvAAO4rUWtbd1DzR"








/*----- DO NOT EDIT THE CODE BELOW! ----*/
/* USER CLASS */
let USER_CLASS_NAME = "User"
let USER_ID = "objectId"
let USER_USERNAME = "username"
let USER_FULLNAME = "fullName"
let USER_PHONE = "phone"
let USER_EMAIL = "email"
let USER_WEBSITE = "website"
let USER_AVATAR = "avatar"



/* CLASSIFIEDS CLASS */
let CLASSIF_CLASS_NAME = "Classifieds"
let CLASSIF_ID = "objectId"
let CLASSIF_USER = "user" // User Pointer
let CLASSIF_TITLE = "title"
let CLASSIF_CATEGORY = "category"
let CLASSIF_AVAILABILITY = "availability"
let CLASSIF_EXPERIENCE = "experience"
let CLASSIF_ADDRESS = "address" // GeoPoint
let CLASSIF_ADDRESS_STRING = "addressString"
let CLASSIF_PRICE = "price"
let CLASSIF_DESCRIPTION = "description"
let CLASSIF_DESCRIPTION_LOWERCASE = "descriptionLowercase"
let CLASSIF_IMAGE1 = "image1" // File
let CLASSIF_IMAGE2 = "image2" // File
let CLASSIF_IMAGE3 = "image3" // File
let CLASSIF_CREATED_AT = "createdAt"
let CLASSIF_UPDATED_AT = "updatedAt"
let CLASSIF_KEYWORDS = "keywords"



/* FAVORITES CLASS */
let FAV_CLASS_NAME = "Favorites"
let FAV_USERNAME = "username"
let FAV_USER_POINTER = "userPointer"
let FAV_AD_POINTER = "adPointer" // Pointer

var CLASSIF_FIRST_NAME = "firstName"
var CLASSIF_Full_NAME = "fullName"
var CLASSIF_LAST_NAME = "lastName"
var CLASSIF_EMAIL = "email"
var CLASSIF_ADDRESS_1 = "address"
var CLASSIF_MOBILE = "phone"
var CLASSIF_DOB = "DOB"
var CLASSIF_SSN = "SSN"
var CLASSIF_BANK = "bank"
var CLASSIF_REGION = "region"
var CLASSIF_POSTALCODE = "postalCode"
var CLASSIF_LOCALITY = "locality"
var CLASSIF_ACCOUNT_NUMBER = "accountNumber"
var CLASSIF_ROUTING_NUMBER = "routingNumber"


