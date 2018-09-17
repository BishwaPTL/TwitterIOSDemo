//
//  HomeViewController.swift
//  TweeterLogin
//
//  Created by PRIMESYS on 9/14/18.
//  Copyright © 2018 Bishwajit Kalita. All rights reserved.
//

import UIKit
import TwitterKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var profileImgView: UIImageView!
    
    @IBOutlet var userNameLabel: UILabel!
    
    @IBOutlet var handlerLabel: UILabel!
    
    @IBOutlet var followingButton: UIButton!
    
    @IBOutlet var followersButton: UIButton!
    
    @IBOutlet var tweetButton: UIButton!
    
    @IBOutlet var customTableView: UITableView!
  
    let Home = HomeView()
    var userArray = [User]()
    var followerArray = [Follower]()
    var followingArray = [Following]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.customTableView.isHidden = true
       self.setTableViewAndTableViewCell()
       let screenName = TWTRTwitter.sharedInstance().sessionStore.session()?.userID
       self.getUserInfo(screenName: screenName!)
       Home.showActivityIndicator(view: self.view)
    }
    
    @IBAction func followingButtonClicked(_ sender: UIButton) {
        self.followingButton.tag = 1
        self.followersButton.tag = 0
        self.followingArray.removeAll()
        self.getFollowingList()
        Home.showActivityIndicator(view: self.view)
        self.followingButton.backgroundColor = UIColor.lightGray
        self.followersButton.backgroundColor = UIColor.clear
    }
    
    @IBAction func followersButtonClicked(_ sender: UIButton) {
        self.followersButton.tag = 1
        self.followingButton.tag = 0
        self.followerArray.removeAll()
        self.getFollowersList()
        Home.showActivityIndicator(view: self.view)
        self.followingButton.backgroundColor = UIColor.clear
        self.followersButton.backgroundColor = UIColor.lightGray
    }
    
    
    @IBAction func tweetButtonClicked(_ sender: UIButton) {
        Home.showAlert(viewController: self)
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        Home.showAlertForLogout(viewController: self)
    }
    
    
    fileprivate func getUserInfo(screenName: String) {
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID:userID)
            let url = "https://api.twitter.com/1.1/account/verify_credentials.json"
            let params = ["screen_name": screenName]
            var clientError : NSError?
            
            let request = client.urlRequest(withMethod: "GET", urlString: url, parameters: params, error: &clientError)
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(String(describing: connectionError))")
                }
                else {
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        print("json: \(String(describing: json))")
                        
                        let userNameStr : String = {
                            
                            if let userName = json?.value(forKey: "name") {
                                return userName as! String
                            }
                            return "no name"
                        }()
                        
                        let handlerStr : String = {
                            
                            if let handler = json?.value(forKey: "screen_name") {
                                return handler as! String
                            }
                            return "no name"
                        }()
                        
                        let statusCountStr : String = {
                            
                            if let statusCount = json?.value(forKey: "statuses_count") {
                                let statusCountInt = statusCount as! Int
                                let strCount = String(statusCountInt)
                                return strCount
                            }
                            return "no status"
                        }()
                        
                        let profileUrlStr : String = {
                            
                            if let profileImgUrl = json?.value(forKey: "profile_image_url") {
                                return profileImgUrl as! String
                            }
                            return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSf2u0RWmYALKJ431XNoTKjzu77ERLBIvXKlOEA-Q3DPo2h2rCB"
                        }()
                        
                        let followersCountStr : String = {
                            
                            if let followersCount = json?.value(forKey: "followers_count") {
                                let followersCountInt = followersCount as! Int
                                let strCount = String(followersCountInt)
                                return strCount
                            }
                            return "no followers"
                        }()
                        
                        let followingCountStr : String = {
                            
                            if let followingCount = json?.value(forKey: "friends_count") {
                                let followingCountInt = followingCount as! Int
                                let strCount = String(followingCountInt)
                                return strCount
                            }
                            return "no followings"
                        }()
                        
                        self.userArray.append(User(userName: userNameStr, handler: handlerStr, statusCount: statusCountStr, profileImgUrl: profileUrlStr, followersCount: followersCountStr, followingCount: followingCountStr))
                        
                        self.updateProfile()
                    }
                    catch let jsonError as NSError {
                        print("json error: \(jsonError.localizedDescription)")
                    }
                }
            }
        }
    }
    
    fileprivate func updateProfile() {
        let url = URL(string: self.userArray[0].profileImgUrl!)
        let data = try? Data.init(contentsOf: url!)
        if(data != nil) {
            let image = UIImage(data: data!)
            self.profileImgView.image = image
            self.profileImgView.layer.cornerRadius = self.profileImgView.frame.size.height/2
            self.profileImgView.layer.cornerRadius = self.profileImgView.frame.size.width/2
            self.profileImgView.clipsToBounds = true
        }
        
        self.userNameLabel.text = self.userArray[0].userName
        self.handlerLabel.text = "@"+self.userArray[0].handler!
        
        self.followingButton.setTitle("Following \n"+self.userArray[0].followingCount!, for: .normal)
        self.followingButton.titleLabel?.numberOfLines = 0
        self.followingButton.titleLabel?.textAlignment = .center
        
        self.followersButton.setTitle("Follower \n"+self.userArray[0].followersCount!, for: .normal)
        self.followersButton.titleLabel?.numberOfLines = 0
        self.followersButton.titleLabel?.textAlignment = .center
        
        self.tweetButton.setTitle("Tweet \n"+self.userArray[0].statusCount!, for: .normal)
        self.tweetButton.titleLabel?.numberOfLines = 0
        self.tweetButton.titleLabel?.textAlignment = .center
        
        self.Home.stopActivityIndicator(view: self.view)
    }
    
    fileprivate func getFollowersList() {
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID:userID)
            let url = "https://api.twitter.com/1.1/followers/list.json"
            var clientError : NSError?
            
            let request = client.urlRequest(withMethod: "GET", urlString: url, parameters: nil, error: &clientError)
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(String(describing: connectionError))")
                }
                else {
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        print("json: \(String(describing: json))")
                        if let arrayObject = json?.value(forKey: "users")
                        {
                            for i in arrayObject as! [Dictionary<String, AnyObject>]
                            {
                                let name : String = {
                                    
                                    if let name = i["name"] {
                                        return name as! String
                                    }
                                    return "no name"
                                }()
                                
                                let profileUrl : String = {
                                    
                                    if let profileUrl = i["profile_image_url"] {
                                        return profileUrl as! String
                                    }
                                    return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSf2u0RWmYALKJ431XNoTKjzu77ERLBIvXKlOEA-Q3DPo2h2rCB"
                                }()
                                
                                let bannerUrl : String = {
                                    
                                    if let bannerUrl = i["profile_banner_url"] {
                                        return bannerUrl as! String
                                    }
                                    return "https://www.fluigent.com/wp-content/uploads/2018/07/logo-twitter-design-1024x191.png"
                                }()
                                
                                let followersCountStr : String = {
                                    
                                    if let followersCount = i["followers_count"] {
                                        let followersCountInt = followersCount as! Int
                                        let strCount = String(followersCountInt)
                                        return strCount
                                    }
                                    return "no followers"
                                }()
                                
                                let followingCountStr : String = {
                                    
                                    if let followingCount = i["friends_count"] {
                                        let followingCountInt = followingCount as! Int
                                        let strCount = String(followingCountInt)
                                        return strCount
                                    }
                                    return "no followings"
                                }()
                                self.followerArray.append(Follower(followerName: name,followerBannerUrl: bannerUrl,followingCount: followingCountStr,followersCount: followersCountStr, followerImgUrl: profileUrl))
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.customTableView.reloadData()
                            })
                            self.customTableView.isHidden = false
                            self.Home.stopActivityIndicator(view: self.view)
                        }
                    }
                    catch let jsonError as NSError {
                        print("json error: \(jsonError.localizedDescription)")
                    }
                }
            }
        }
    }
    
    fileprivate func getFollowingList() {
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID:userID)
            let url = "https://api.twitter.com/1.1/friends/list.json"
            var clientError : NSError?
            
            let request = client.urlRequest(withMethod: "GET", urlString: url, parameters: nil, error: &clientError)
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(String(describing: connectionError))")
                }
                else {
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        print("json: \(String(describing: json))")
                        
                        if let arrayObject = json?.value(forKey: "users")
                        {
                            for i in arrayObject as! [Dictionary<String, AnyObject>]
                            {
                                let name : String = {
                                    
                                    if let name = i["name"] {
                                        return name as! String
                                    }
                                    return "no name"
                                }()
                                
                                let profileUrl : String = {
                                    
                                    if let profileUrl = i["profile_image_url"] {
                                        return profileUrl as! String
                                    }
                                    return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSf2u0RWmYALKJ431XNoTKjzu77ERLBIvXKlOEA-Q3DPo2h2rCB"
                                }()
                                
                                let bannerUrl : String = {
                                    
                                    if let bannerUrl = i["profile_banner_url"] {
                                        return bannerUrl as! String
                                    }
                                    return "https://www.fluigent.com/wp-content/uploads/2018/07/logo-twitter-design-1024x191.png"
                                }()
                                
                                let followersCountStr : String = {
                                    
                                    if let followersCount = i["followers_count"] {
                                        let followersCountInt = followersCount as! Int
                                        let strCount = String(followersCountInt)
                                        return strCount
                                    }
                                    return "no followers"
                                }()
                                
                                let followingCountStr : String = {
                                    
                                    if let followingCount = i["friends_count"] {
                                        let followingCountInt = followingCount as! Int
                                        let strCount = String(followingCountInt)
                                        return strCount
                                    }
                                    return "no followings"
                                }()
                                self.followingArray.append(Following(followerName: name, followerBannerUrl: bannerUrl, followingCount: followersCountStr, followersCount: followingCountStr, followerImgUrl: profileUrl))
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.customTableView.reloadData()
                            })
                            self.customTableView.isHidden = false
                            self.Home.stopActivityIndicator(view: self.view)
                        }
                    }
                    catch let jsonError as NSError {
                        print("json error: \(jsonError.localizedDescription)")
                    }
                }
            }
        }
    }
    
    fileprivate func setTableViewAndTableViewCell() {
        self.customTableView.delegate = self
        self.customTableView.dataSource = self
        self.customTableView.backgroundColor = UIColor.clear
        let nib = UINib(nibName: "customTableViewCell", bundle: nil)
        self.customTableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if(self.followersButton.tag == 1)
        {
            return self.followerArray.count
        }
        else if(self.followingButton.tag == 1)
        {
            return self.followingArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:customTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! customTableViewCell
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        cell.contentView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        if(self.followersButton.tag == 1)
        {
           cell.profileNameLabel.text = self.followerArray[indexPath.section].followerName
           cell.followingLabel.text = "Following \n"+self.followerArray[indexPath.section].followingCount!
           cell.followerLabel.text = "Follower \n"+self.followerArray[indexPath.section].followersCount!
           
           cell.profileImageFromServerURL(urlString: self.followerArray[indexPath.section].followerImgUrl!)
           cell.bannerImageFromServerURL(urlString: self.followerArray[indexPath.section].followerBannerUrl!)
        }
        else if(self.followingButton.tag == 1)
        {
            cell.profileNameLabel.text = self.followingArray[indexPath.section].followerName
            cell.followingLabel.text = "Following \n"+self.followingArray[indexPath.section].followingCount!
            cell.followerLabel.text = "Follower \n"+self.followingArray[indexPath.section].followersCount!
            
            cell.profileImageFromServerURL(urlString: self.followingArray[indexPath.section].followerImgUrl!)
            cell.bannerImageFromServerURL(urlString: self.followingArray[indexPath.section].followerBannerUrl!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            return 350
        }
        else {
            return 200
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 {
            return 0
        }
        else {
            tableView.sectionHeaderHeight = 10
        }
        return 0
    }
    
/*
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 5.0
    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
