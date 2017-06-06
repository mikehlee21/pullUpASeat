//
//  SinUpOption.swift
//  PullUpASeat
//
//  Created by iphone on 04/08/16.
//  Copyright © 2016 Pull-Up-A-Seat. All rights reserved.
//

import UIKit

class SinUpOption: UIViewController {

    override func viewDidLoad() {
                super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func foodyAccount(_ sender: UIButton) {
        let signupVC = self.storyboard?.instantiateViewController(withIdentifier: "Signup") as! Signup
        navigationController?.pushViewController(signupVC, animated: true)
    }

   
    @IBAction func hostAccount(_ sender: AnyObject) {
        let signupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpWeb") as! SignUpWeb
        navigationController?.pushViewController(signupVC, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
