//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    func refreshData(_ refreshControl: UIRefreshControl) {
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
            refreshControl.endRefreshing()
        }
    }
    
    @IBAction func didTapFav(_ sender: Any) {
        print("didTapFav")
        
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets[indexPath!.row]

        print("fav status: \(tweet.favorited!)")
        
        if tweet.favorited! == false {
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                    self.tweets[indexPath!.row].favoriteCount += 1
                    //tweet.favorited = true
                    self.tweets[indexPath!.row].favorited = true
                    cell.favTweetbutton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
                    self.tableView.reloadData()
                }
            }
        } else {
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                    self.tweets[indexPath!.row].favoriteCount -= 1
                    self.tweets[indexPath!.row].favorited = false
                    cell.favTweetbutton.setImage(UIImage(named: "favor-icon"), for: .normal)
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        print("didTapRetweet")
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets[indexPath!.row]
        
        print("retweet status: \(tweet.favorited!)")
        
        if tweet.retweeted == false {
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                    self.tweets[indexPath!.row].retweetCount += 1
                    self.tweets[indexPath!.row].retweeted = true
                    cell.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
                    self.tableView.reloadData()
                }
            }
        } else {
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unretweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                    self.tweets[indexPath!.row].retweetCount -= 1
                    self.tweets[indexPath!.row].retweeted = false
                    cell.retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func didTapReply(_ sender: Any) {
         print("didTapReply")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        
        if tweet.retweeted {
            cell.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        } else {
            cell.retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
        
        if tweet.favorited! {
            cell.favTweetbutton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            cell.favTweetbutton.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tweet = tweets[indexPath.row]
        print("tweet text: \(tweet.text)")
        print("retweet status: \(tweet.retweeted)")
        print("retweet count: \(tweet.retweetCount)")
        print("favorite status: \(tweet.favorited!)")
        print("favorite count: \(tweet.favoriteCount)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ComposeViewController
        destinationVC.delegate = self

//        if let profileImageUrl = User.current?.profileUrl {
//            destinationVC.profileImageView.af_setImage(withURL: profileImageUrl)
//        }
     }
    
}

extension TimelineViewController: ComposeViewControllerDelegate {
    func did(post: Tweet) {
        dismiss(animated: true, completion: nil)
    }
}
