//
//  TweetViewController.swift
//  Twetify
//
//  Created by ALBERT TADROS on 3/16/22.
//

import UIKit

class TweetViewController: UIViewController {
    
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder() // to make the screen cursor ready to typying
        
        }
    
    
    @IBAction func cancelTweet(_ sender: Any) {
        dismiss(animated: true)
        
    }
    
    @IBAction func fireTweet(_ sender: Any) {
        if (!self.tweetTextView.text!.isEmpty){
            print("I am inside the fireTweet")
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                print("Tweeting succeed and the tweet is ", self.tweetTextView.text!)
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("error posting the tweet \(error)")
                self.dismiss(animated: true, completion: nil)
                
            })
        }
        else {
            self.dismiss(animated: true, completion: nil)
            
        }
         
        
    }
    
}
