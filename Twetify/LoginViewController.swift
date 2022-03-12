//
//  LoginViewController.swift
//  Twetify
//
//  Created by ALBERT TADROS on 3/11/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    

    @IBAction func onClickButton(_ sender: Any) {
        print("Button fired")
        
        TwitterAPICaller.client?.login(url: "https://api.twitter.com/oauth/request_token",
                                       success: {
            UserDefaults.standard.set(true, forKey: "userLoggedIn") // to remember user logging in. To stay logged in
            self.performSegue(withIdentifier: "loginToHome", sender: self)
            print("Logged in Successfully")
        },
                                       failure: { Error in
            print("Could not Login")
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
