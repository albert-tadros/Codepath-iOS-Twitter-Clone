//
//  TwitterAPICaller.swift
//  Twetify
//
//  Created by ALBERT TADROS on 3/11/22.
//

import UIKit
import BDBOAuth1Manager

class TwitterAPICaller: BDBOAuth1SessionManager {
    static let client = TwitterAPICaller(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "FzxbBVekvuOFe7EnBfQbvMlsQ", consumerSecret: "n6rRUJC3fCU7ycALMJkhA1IUGC0OfbikeOMUzTmLfRy7Hh0BPl")
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?

    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterAPICaller.client?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            self.loginSuccess?()
        }, failure: { (error: Error!) in
            self.loginFailure?(error)
        })
    }

    func login(url: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        loginSuccess = success
        loginFailure = failure
        TwitterAPICaller.client?.deauthorize()
        TwitterAPICaller.client?.fetchRequestToken(withPath: url, method: "GET", callbackURL: URL(string: "alamoTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
//            print("I am in the API caller login function. The token is", requestToken.token!)
//            print("I am in the API caller login function. The url is", url)
            UIApplication.shared.open(url)
        }, failure: { (error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
            self.loginFailure?(error)
        })
    }
    func logout (){
        deauthorize()
    }

    func getDictionaryRequest(url: String, parameters: [String:Any], success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()){
        TwitterAPICaller.client?.get(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success(response as! NSDictionary)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    func getDictionariesRequest(url: String, parameters: [String:Any], success: @escaping ([NSDictionary]) -> (), failure: @escaping (Error) -> ()){
        TwitterAPICaller.client?.get(url, parameters: ["include_entities": true], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success(response as! [NSDictionary])
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    func postRequest(url: String, parameters: [Any], success: @escaping () -> (), failure: @escaping (Error) -> ()){
        TwitterAPICaller.client?.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func postTweet(tweetString: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let url = "https://api.twitter.com/1.1/statuses/update.json"
        print("I am inside postTweet and the tweet is ", tweetString)
        TwitterAPICaller.client?.post(url, parameters: ["status" : tweetString], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            print("succeded to post a tweet")
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            print("failed to post a tweet")
        })
    }
    
    func favoriteTweet (tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let url = "https://api.twitter.com/1.1/favorites/create.json"
        TwitterAPICaller.client?.post(url, parameters: ["id" : tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            print("succeded to like a tweet")
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            print("failed to like a tweet")
        })
    }
    
    func unfavoriteTweet(tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let url = "https://api.twitter.com/1.1/favorites/destroy.json"
        TwitterAPICaller.client?.post(url, parameters: ["id" : tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            print("succeded to un-like a tweet")
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            print("failed to un-like a tweet")
        })
    }
    func reTweet(tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let url = "https://api.twitter.com/1.1/statuses/retweet/\(tweetId).json"
        TwitterAPICaller.client?.post(url, parameters: ["id" : tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            print("succeded to retweet a tweet")
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            print("failed to retweet a tweet")
        })
    }
    func unReTweet(tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let url = "https://api.twitter.com/1.1/statuses/unretweet/\(tweetId).json"
        TwitterAPICaller.client?.post(url, parameters: ["id" : tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            print("succeded to retweet a tweet")
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            print("failed to retweet a tweet")
        })
    }

}
