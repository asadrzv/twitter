//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Asad Rizvi on 10/1/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets = 10
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loads all tweets to home page
        loadTweets()
        
        // Pull to refresh the screen and load more tweets
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        self.tableView.refreshControl = myRefreshControl
         
        // Automatically calculate height of text and set initial value to 150
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Loads all tweets to home page
        self.loadTweets()
    }
    
    // Load all tweets onto user's home page
    @objc func loadTweets() {
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["counts": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            // Removes all previous tweets from list
            self.tweetArray.removeAll()
            
            // Adds tweets to list of tweets
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            // Reloads tweet data when new date retrieved
            self.tableView.reloadData()
            
            // Stop refreshing the tweets after pull to refresh
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Failed to retrieve tweets!")
            print(Error.localizedDescription)
        })
    }
    
    // Infinitly loads more tweets when scrolling down
    func loadMoreTweets() {
        numberOfTweets = numberOfTweets + 10
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["counts": numberOfTweets]

        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            // Removes all previous tweets from list
            self.tweetArray.removeAll()
            
            // Adds tweets to list of tweets
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            // Reloads tweet data when new date retrieved
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Failed to retrieve tweets!")
            print(Error.localizedDescription)
        })
    }
    
    // Calls loadMoreTweets() when user scolls to bottom of all current tweets
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    // Populate table view cells with user name/image and tweet contents
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        // Adds user name to cells
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        
        // Adds tweet content to cell
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as? String
        
        // Adds profile image to cell
        let imageUrl = URL(string: (user["profile_image_url_https"] as! String))
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        // Set color of favorite icon (red or grey)
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        
        // Set tweet id of favorited/retweeted tweet
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }
    
    // Processes user logout
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        
        // Goes back to login screen
        self.dismiss(animated: true, completion: nil)
        
        // userLoggedIn = false when user logs out
        UserDefaults.standard.setValue(false, forKey: "userLoggedIn")
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
