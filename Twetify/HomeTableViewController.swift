//
//  HomeTableViewController.swift
//  Twetify
//
//  Created by ALBERT TADROS on 3/11/22.

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets : Int!
    
    let myRefreshControl = UIRefreshControl() // for pull down refresh
    

    override func viewDidLoad() {
        //self.loadTweets()
        super.viewDidLoad()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        self.tableView.refreshControl = myRefreshControl // telling the table which refresh control it need to implement when refreshing
//        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()

    }
    
    @objc  func loadTweets() {
        let tweetUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = 10
        let myParams = ["count" : numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetUrl,
                                                        parameters: myParams as [String : Any],
                                                        success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            //print(self.tweetArray)
            self.tableView.reloadData() // to reload the tableview with data after the data has been fetched from the api
            self.myRefreshControl.endRefreshing()
            
            print("number of tweets", self.tweetArray.count)
        },
                                                        failure: { (Error) in
            print("could not fetch tweet data")
        })
    }
    func loadMoreTweets() {
        let tweetUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = numberOfTweets + 20
        let myParams = ["count" : numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetUrl,
                                                        parameters: myParams as [String: Any],
                                                        success: { (tweets: [NSDictionary]) in
            //self.tweetArray = tweets
            
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            //print(self.tweetArray)
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count{
            loadMoreTweets()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        // the api repsonse dictionary == tweetArray
        let tweet = tweetArray[indexPath.row]
        print("The tweet object is :", tweet)
        
        // in the api repsonse main dictionary == tweetArray
        let tweetText = tweet["text"] as! String
        
        // the "user" dictionary inside the the api repsonse main dictionary
        let user = tweet["user"]as! NSDictionary // in the api response, "user" is a dictionary
        let username = user["name"] as! String
        let imageURL = URL(string : user["profile_image_url_https"] as! String)!
        

        cell.userNameLabel.text = username
        cell.tweetContent.text = tweetText
        cell.profileImageView.af.setImage(withURL: imageURL)
        
        // favoriting
        cell.id = tweet["id"] as! Int // to pass the tweet id to cellViewController
        cell.setFavorite(tweet["favorited"] as! Bool) // to get and set the state of the favorited tweets
        
        // retweeting
        cell.setRetweeted(tweet["retweeted"] as! Bool) // to get and set the initial retweeted state of a tweet
        cell.retweeted = tweet["retweeted"] as! Bool // to pass the tweet id to cellViewController
    
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
