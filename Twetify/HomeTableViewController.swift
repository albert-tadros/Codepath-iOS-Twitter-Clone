//
//  HomeTableViewController.swift
//  Twetify
//
//  Created by ALBERT TADROS on 3/11/22.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets : Int!
    
    let myRefreshControl = UIRefreshControl() // for pull down refresh
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshControl // telling the table which refresh control it need to implement when refreshing
    }
    
    @objc  func loadTweet() {
        let tweetUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count" : 10]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetUrl,
                                                        parameters: myParams,
                                                        success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            print(self.tweetArray)
            self.tableView.reloadData() // to reload the tableview with data after the data has been fetched from the api
            self.myRefreshControl.endRefreshing()
            
            print("number of tweets", self.tweetArray.count)
        },
                                                        failure: { (Error) in
            print("could not fetch tweet data")
        })
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion:nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        print("Logged out Sucessfully")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        // the api repsonse dictionary == tweetArray
        let tweet = tweetArray[indexPath.row]
        
        // in the api repsonse main dictionary == tweetArray
        let tweetText = tweet["text"] as! String
        
        // the "user" dictionary inside the the api repsonse main dictionary
        let user = tweet["user"]as! NSDictionary // in the api response, "user" is a dictionary
        let username = user["name"] as! String
        let imageURL = URL(string : user["profile_image_url_https"] as! String)!
        

        cell.userNameLabel.text = username
        cell.tweetContent.text = tweetText
        cell.profileImageView.af.setImage(withURL: imageURL)
        
        return cell
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
        
    }

}
