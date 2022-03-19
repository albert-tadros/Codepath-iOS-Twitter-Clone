//
//  TweetCellTableViewCell.swift
//  Twetify
//
//  Created by ALBERT TADROS on 3/11/22.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    
    var favorited : Bool = false
    var id : Int = -1 // tweet ID passed from homecontrolview
    var retweeted : Bool = false //retweeted status passed from homecontrolview
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    
    @IBAction func retweet(_ sender: Any) {
        retweeted = !retweeted
        if(retweeted == true){
            TwitterAPICaller.client?.reTweet(tweetId: id, success: {
                self.setRetweeted(self.retweeted)
            }, failure: { (Error) in
                print("couldn't retweet \(Error)")
                
            })
        }else {
            TwitterAPICaller.client?.unReTweet(tweetId: id, success: {
                self.setRetweeted(self.retweeted)
            }, failure: { (Error) in
                print("failed to unretweet \(Error)")
            })
        }
    }
    
    @IBAction func favoriteTweet(_ sender: Any) {
        favorited = !favorited
        if (favorited == true) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: id, success: {
                self.setFavorite(self.favorited)
            }, failure: { (Error) in
                print("unable to set tweet as favorited")
            })
        }else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: id, success: {
                self.setFavorite(self.favorited)
            }, failure: { (Error) in
                print("unable to set un favor a tweet")
            })
        }
    }
    
    func setFavorite(_ isFavorited:Bool){
        favorited = isFavorited
        if(favorited){
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
        
    }
    
    func setRetweeted(_ isRetweeted: Bool){
        if(isRetweeted){
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
        }else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
