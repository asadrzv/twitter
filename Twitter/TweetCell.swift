//
//  TweetCell.swift
//  Twitter
//
//  Created by Asad Rizvi on 10/1/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var favorited: Bool = false
    var tweetId: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // Favorite/Unfavrite a tweet on the home page
    @IBAction func favoriteTweet(_ sender: Any) {
        let toFavorite = !favorited
        
        if toFavorite {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { (Error) in
                print("Favorite failed: \(Error)")
            })
        } else {
            TwitterAPICaller.client?.unFavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (Error) in
                print("Unfavorite failed: \(Error)")
            })
        }
    }
    
    // Retweet a tweet on the home page
    @IBAction func retweetTweet(_ sender: Any) {
        TwitterAPICaller.client?.retweetTweet(tweetId: tweetId, success: {
            self.setRetweeted(true)
        }, failure: { (Error) in
            print("Retweet failed: \(Error)")
        })
    }
    
    // Sets favorite button icon red/grey if favorited or not
    func setFavorite(_ isFavorited: Bool) {
        favorited = isFavorited
        
        // Set favorite button icon red (i.e. favorited)
        if favorited {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        // Set favorite button icon grey (i.e. not favorited)
        else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    // Sets retweet button icon green/grey if retweeted or not
    func setRetweeted(_ isRetweeted: Bool) {
        // Set retweet button icon green (i.e. retweeted)
        if isRetweeted {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        }
        // Set retweet button icon grey (i.e. not retweeted)
        else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
}
