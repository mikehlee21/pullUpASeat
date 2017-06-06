/* =======================

 - PullUpASeat -
 
 made by Camille Baker ©2016

==========================*/

import UIKit
import Parse


class Login: UIViewController,
UITextFieldDelegate,
UIAlertViewDelegate
{

    /* Views */
    //@IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var loginOutlet: UIButton!
    @IBOutlet var signupOutlet: UIButton!
    @IBOutlet weak var fbOutlet: UIButton!
    
    @IBOutlet var bkgViews: [UIView]!

    var flag_check = false
    @IBOutlet weak var checkImageView: UIImageView!
    
    
    

override func viewWillAppear(_ animated: Bool) {
    if PFUser.current() != nil {
        _ = navigationController?.popViewController(animated: true)
    }
}
override func viewDidLoad() {
        super.viewDidLoad()
    
    self.title = "LOGIN"
    
    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
    navigationItem.leftBarButtonItem = backButton
    self.navigationController?.isNavigationBarHidden = true
    
    // Round views corners
    loginOutlet.layer.cornerRadius = 19
    //signupOutlet.layer.cornerRadius = 5
    fbOutlet.layer.cornerRadius = 5
    for view in bkgViews { view.layer.cornerRadius = 8 }

    checkImageView.image = UIImage(named: "uncheck1")
    
    //containerScrollView.contentSize = CGSize(width: view.frame.size.width, height: 550)
}

    
// MARK: - LOGIN BUTTON
@IBAction func loginButt(_ sender: AnyObject) {
    passwordTxt.resignFirstResponder()
    showHUD()

    PFUser.logInWithUsername(inBackground: usernameTxt.text!, password:passwordTxt.text!) {
        (user, error) -> Void in
        
        if user != nil { // Login successfull
            self.hideHUD()
            _ = self.navigationController?.popViewController(animated: true)
            
        } else { // Login failed. Try again
            let alert = UIAlertView(title: APP_NAME,
            message: "Login Error",
            delegate: self,
            cancelButtonTitle: "Retry",
            otherButtonTitles: "Sign Up")
            alert.show()
            self.hideHUD()
    }}
    
}
// AlertView delegate
func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
    if alertView.buttonTitle(at: buttonIndex) == "Sign Up" {
        signupButt(self)
    }
    
    if alertView.buttonTitle(at: buttonIndex) == "Reset Password" {
        if alertView.textField(at: 0)?.text != "" {
            PFUser.requestPasswordResetForEmail(inBackground: "\(alertView.textField(at: 0)!.text!)")
            showNotifAlert()
        } else {
            simpleAlert("Field cannot be empty!")
        }
    }
}


    
    
// MARK: - SIGNUP BUTTON
@IBAction func signupButt(_ sender: AnyObject) {
    let signupVC = self.storyboard?.instantiateViewController(withIdentifier: "SinUpOption") as! SinUpOption
    navigationController?.pushViewController(signupVC, animated: true)
}
  
  //  Signup
    
    
    
// MARK: - TEXTFIELD DELEGATES
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == usernameTxt { passwordTxt.becomeFirstResponder() }
    if textField == passwordTxt  { passwordTxt.resignFirstResponder() }
    
return true
}
    
    

// MARK: - TAP THE VIEW TO DISMISS KEYBOARD
@IBAction func tapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
    usernameTxt.resignFirstResponder()
    passwordTxt.resignFirstResponder()
}
    
    
    
// MARK: - FORGOT PASSWORD BUTTON
@IBAction func forgotPasswButt(_ sender: AnyObject) {
    let alert = UIAlertView(title: APP_NAME,
        message: "Type your email address you used to register.",
        delegate: self,
        cancelButtonTitle: "Cancel",
        otherButtonTitles: "Reset Password")
    alert.alertViewStyle = UIAlertViewStyle.plainTextInput
    alert.show()
}


// MARK: - NOTIFICATION ALERT FOR PASSWORD RESET
func showNotifAlert() {
    simpleAlert("You will receive an email shortly with a link to reset your password")
}
    

    @IBAction func keepmeLoginBtnTabbed(_ sender: Any) {
        
        if flag_check {
            
            checkImageView.image = UIImage(named: "uncheck1")
            flag_check = false
            
        } else {
            
            checkImageView.image = UIImage(named: "check1")
            flag_check = true
            
        }
        
        
    }
    
    
    
    
override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
}
}
