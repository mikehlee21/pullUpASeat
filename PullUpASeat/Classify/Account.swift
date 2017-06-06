/* =======================
 
 - PullUpASeat -
 
 made by Camille Baker ©2016


==========================*/


import UIKit
import Parse

class Account: UIViewController,
UITextFieldDelegate,
UIAlertViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
{

    /* Views */
    @IBOutlet var containerScrollView: UIScrollView!
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var fullnameTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var phoneTxt: UITextField!
    @IBOutlet var websiteTxt: UITextField!
    @IBOutlet var saveProfileOutlet: UIButton!
    @IBOutlet var myAdsOutlet: UIButton!
    
    
    /* Variables */
    var userArray = [PFObject]()
    var currUserUpdated = Bool()
    
    
    
    
    
// MARK: - CHECK IF USER IS LOGGED IN
override func viewWillAppear(_ animated: Bool) {
    if PFUser.current() == nil {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
        navigationController?.pushViewController(loginVC, animated: false)
    } else {
        showUserDetails()
    }
}
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    // Round views corners
    avatarImage.layer.cornerRadius = avatarImage.bounds.size.width/2
    saveProfileOutlet.layer.cornerRadius = 8
    myAdsOutlet.layer.cornerRadius = 8
    
    containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: 600)
    
    // Show user's details
    // if PFUser.currentUser() != nil { showUserDetails() }
}

    

// MARK: - SHOW USER DETIALS
func showUserDetails() {
    let currUser = PFUser.current()!
    
    usernameLabel.text = "\(currUser[USER_USERNAME]!)"
    emailTxt.text = "\(currUser[USER_EMAIL]!)"
    
    if currUser[USER_FULLNAME] != nil {
        fullnameTxt.text = "\(currUser[USER_FULLNAME]!)"
    } else { fullnameTxt.text = "" }
    
    if currUser[USER_PHONE] != nil {
        phoneTxt.text = "\(currUser[USER_PHONE]!)"
    } else { phoneTxt.text = "" }
    
    if currUser[USER_WEBSITE] != nil {
        websiteTxt.text = "\(currUser[USER_WEBSITE]!)"
    } else { websiteTxt.text = "" }
    
     // Get Avatar image
    if avatarImage.image == nil {
        let imageFile = currUser[USER_AVATAR] as? PFFile
        imageFile?.getDataInBackground (block: { (imageData, error) -> Void in
            if error == nil {
                if let imageData = imageData {
                    self.avatarImage.image = UIImage(data:imageData)
        }}})
    }
    
}
    
    
    
// MARK: - TEXTFIELD DELEGATE
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == fullnameTxt {  emailTxt.becomeFirstResponder()  }
    if textField == emailTxt    {  phoneTxt.becomeFirstResponder()  }
    if textField == phoneTxt    {  websiteTxt.becomeFirstResponder()  }
    if textField == websiteTxt  {  websiteTxt.resignFirstResponder()  }

return true
}

    
// MARK: - CHANGE IMAGE BUTTON
@IBAction func changeImageButt(_ sender: AnyObject) {
    let alert = UIAlertView(title: APP_NAME,
    message: "Add a Photo",
    delegate: self,
    cancelButtonTitle: "Cancel",
    otherButtonTitles:
            "Take a picture",
            "Choose from Library"
    )
    alert.show()
    
}
// AlertView delegate
func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.buttonTitle(at: buttonIndex) == "Take a picture" {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            
        } else if alertView.buttonTitle(at: buttonIndex) == "Choose from Library" {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
}
// ImagePicker Delegate
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
    avatarImage.image = image
    dismiss(animated: true, completion: nil)
}
    
    
    
    

// MARK: - SAVE PROFILE BUTTON
@IBAction func saveProfileButt(_ sender: AnyObject) {
    showHUD()
    dismissKeyboard()
    
    let currentUser = PFUser.current()!
    currentUser[USER_FULLNAME] = fullnameTxt.text
    currentUser[USER_EMAIL] = emailTxt.text
    currentUser[USER_PHONE] = phoneTxt.text
    currentUser[USER_WEBSITE] = websiteTxt.text

    // Save Image (if exists)
    if avatarImage.image != nil {
        let imageData = UIImageJPEGRepresentation(avatarImage.image!,0.2)
        let imageFile = PFFile(name:"avatar.jpg", data:imageData!)
        currentUser[USER_AVATAR] = imageFile
    }
    
    // Saving block
    currentUser.saveInBackground { (success, error) -> Void in
        if error == nil {
            self.simpleAlert("Your Profile has been updated!")
            self.hideHUD()
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
}

    
    
// MARK: - POST A NEW AD BUTTON
@IBAction func postAdButt(_ sender: AnyObject) {
    let postVC = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! Post
    present(postVC, animated: true, completion: nil)
}
    
    
    
// MARK: - MY ADS BUTTON
@IBAction func myAdsButt(_ sender: AnyObject) {
    let myAdsVC = self.storyboard?.instantiateViewController(withIdentifier: "MyAdsNew") as! MyAdsNew
    self.navigationController?.pushViewController(myAdsVC, animated: true)
}
    
    
    
// MARK: - LOGOUT BUTTON
@IBAction func logoutButt(_ sender: AnyObject) {
    PFUser.logOut()
    
    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
    navigationController?.pushViewController(loginVC, animated: true)
}
  

    
// MARK: - TAP TO DISMISS KEYBOARD
@IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
  dismissKeyboard()
}
  
    
func dismissKeyboard() {
    fullnameTxt.resignFirstResponder()
    emailTxt.resignFirstResponder()
    phoneTxt.resignFirstResponder()
    websiteTxt.resignFirstResponder()
}

    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
