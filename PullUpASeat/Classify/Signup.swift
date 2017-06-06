/* =======================
 
 - PullUpASeat -
 
 made by Camille Baker ©2016
 
 
 ==========================*/


import UIKit
import Parse


class Signup: UIViewController,
    UITextFieldDelegate
{
    
    /* Views */
    //@IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var signupOutlet: UIButton!
    @IBOutlet weak var touOutlet: UIButton!
    
    @IBOutlet var bkgViews: [UIView]!
    
    @IBOutlet weak var textView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SIGN UP"
        
        // Round views corners
        signupOutlet.layer.cornerRadius = 19
        touOutlet.layer.cornerRadius = 5
        for view in bkgViews { view.layer.cornerRadius = 8
        }
        
        textView.isHidden = true
        touOutlet.isHidden = true
        //containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width,height: 300)
    }
    
    
// MARK: - TAP TO DISMISS KEYBOARD
@IBAction func tapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        emailTxt.resignFirstResponder()
}
    
// MARK: - SIGNUP BUTTON
    @IBAction func signupButt(_ sender: AnyObject) {
        if usernameTxt.text == "" || passwordTxt.text == "" || emailTxt.text == "" {
            simpleAlert("You must fill all the fields to Sign Up!")
            
        } else {
            showHUD()
            let userForSignUp = PFUser()
            userForSignUp.username = usernameTxt.text
            userForSignUp.password = passwordTxt.text
            userForSignUp.email = emailTxt.text
            
            userForSignUp.signUpInBackground { (succeeded, error) -> Void in
                if error == nil { // Successful Signup
              //if success Trigger external mail to the user mail id  --- pathced By Nestweaver
                    PFCloud.callFunction(inBackground: "sendEmailtoclient", withParameters: ["username": (string : self.usernameTxt.text as Any), "email": (string: self.emailTxt.text as Any)])
                    // end
                    
                    _ = self.navigationController?.popToRootViewController(animated: true)
                    self.hideHUD()
                    
                    // error
                } else {
                    self.simpleAlert("\(error!.localizedDescription)")
                    self.hideHUD()
                }}
            
        }
    }
    
    // MARK: - TEXTFIELD DELEGATES
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTxt {   passwordTxt.becomeFirstResponder()  }
        if textField == passwordTxt {  emailTxt.becomeFirstResponder()  }
        if textField == emailTxt {   emailTxt.resignFirstResponder()   }
        return true
    }
    
    // MARK: - TERMS OF USE BUTTON
    @IBAction func touButt(_ sender: AnyObject) {
        let touVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsOfUse") as! TermsOfUse
        present(touVC, animated: true, completion: nil)
    }
    
    //WELCOME EMAIL
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
}

