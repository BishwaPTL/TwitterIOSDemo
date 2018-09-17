//
//  Following.swift
//  TweeterLogin
//
//  Created by Jekib Alam Haque on 15/09/18.
//  Copyright © 2018 Bishwajit Kalita. All rights reserved.
//

import Foundation

class Following {
    let followerName : String?
    let followerBannerUrl : String?
    let followingCount : String?
    let followersCount : String?
    let followerImgUrl : String?
    
    init(followerName: String, followerBannerUrl: String, followingCount: String, followersCount: String, followerImgUrl : String) {
        
        self.followerName = followerName
        self.followerBannerUrl = followerBannerUrl
        self.followingCount = followingCount
        self.followersCount = followersCount
        self.followerImgUrl = followerImgUrl
    }
}
