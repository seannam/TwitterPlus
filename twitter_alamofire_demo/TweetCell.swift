//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            usernameLabel.text = tweet.user.name
            screenameLabel.text = "@\(tweet.user.screenname)"
            timestampLabel.text = tweet.createdAtString
            
            if let profileImageUrl = tweet.user.profileUrl {
                profileImageView.af_setImage(withURL: profileImageUrl)
            }
            
            retweetLabel.text = String(tweet.retweetCount)
            favCountLabel.text = String(describing: tweet.favoriteCount!)
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
    
    @IBAction func onReplyButton(_ sender: Any) {
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
    }
    
    @IBAction func onFavButton(_ sender: Any) {
    }
}
