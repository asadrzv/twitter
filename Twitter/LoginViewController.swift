//
//  LoginViewController.swift
//  Twitter
//
//  Created by Asad Rizvi on 9/30/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Make sure user stays logged-in
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    // Processes user login
    @IBAction func onLoginButton(_ sender: Any) {
        let myUrl = "https://api.twitter.com/oauth/request_token"
        
        // User succesfully logged-in
        TwitterAPICaller.client?.login(url: myUrl, success: {
            // userLoggedIn = true when user succesfully logs-in
            UserDefaults.standard.setValue(true, forKey: "userLoggedIn")
            
            // Segue way Home screen when login succesful
            self.performSegue(withIdentifier: "loginToHome", sender: self)
            
            // User failed to login
        }, failure: { (Error) in
            print("Login failed!")
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
