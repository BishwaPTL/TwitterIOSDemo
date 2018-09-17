//
//  customTableViewCell.swift
//  TweeterLogin
//
//  Created by PRIMESYS on 9/15/18.
//  Copyright © 2018 Bishwajit Kalita. All rights reserved.
//

import UIKit

class customTableViewCell: UITableViewCell {
    
    @IBOutlet var bannerImgView: UIImageView!
    
    @IBOutlet var profileImgView: UIImageView!
    
    @IBOutlet var profileNameLabel: UILabel!
    
    @IBOutlet var followingLabel: UILabel!
    
    @IBOutlet var followerLabel: UILabel!
    
    var profileImage : UIImage?
    var bannerImage : UIImage?
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        profileImgView.layer.cornerRadius = profileImgView.frame.size.height/2
        profileImgView.layer.cornerRadius = profileImgView.frame.size.width/2
        profileImgView.clipsToBounds = true
    }
    
    public func profileImageFromServerURL(urlString: String) {
        self.profileImage = nil
        
        if let imageFromCache = self.imageCache.object(forKey: urlString as AnyObject) as? UIImage
        {
            self.profileImage = imageFromCache
            self.profileImgView.image = self.profileImage
            return
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: { () -> Void in
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let imageToCache = UIImage(data: data!)
                if(imageToCache != nil) {
                self.imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                self.profileImage = imageToCache
                self.profileImgView.image = self.profileImage
                }
            })
        }).resume()
    })
}
    
    public func bannerImageFromServerURL(urlString: String) {
        self.bannerImage = nil
        
        if let imageFromCache = self.imageCache.object(forKey: urlString as AnyObject) as? UIImage
        {
            self.bannerImage = imageFromCache
            self.bannerImgView.image = self.bannerImage
            return
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: { () -> Void in
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let imageToCache = UIImage(data: data!)
                if(imageToCache != nil) {
                    self.imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                    self.bannerImage = imageToCache
                    self.bannerImgView.image = self.bannerImage
                }
            })
        }).resume()
     })
  }
}
