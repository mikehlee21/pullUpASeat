//
//  SignUpWeb.swift
//  PullUpASeat
//
//  Created by lucky clover on 3/10/17.
//  Copyright © 2017 Pull-Up-A-Seat. All rights reserved.
//

import UIKit

class SignUpWeb: UIViewController {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(NSURLRequest(url: NSURL(string: "https://pullupaseat.formstack.com/forms/new_host_trigger")! as URL) as URLRequest)
    }
}
