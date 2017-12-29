//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import Alamofire

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            usernameLabel.text = tweet.user.name
            screenameLabel.text = tweet.user.screenname
            timestampLabel.text = tweet.createdAtString
            
            if tweet.user.profileImageUrlString != nil {
                let profileImageURL = URL(string: tweet.user.profileImageUrlString)
                //profileImageView.setImageWith(profileImageURL)
            }
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
