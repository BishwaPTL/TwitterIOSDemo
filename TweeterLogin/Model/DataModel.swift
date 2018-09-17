//
//  DataModel.swift
//  TweeterLogin
//
//  Created by PRIMESYS on 9/14/18.
//  Copyright © 2018 Bishwajit Kalita. All rights reserved.
//

import Foundation

class User {
    let userName : String?
    let handler : String?
    let statusCount : String?
    let profileImgUrl: String?
    let followersCount : String?
    let followingCount : String?
    
    init(userName: String, handler: String, statusCount: String, profileImgUrl: String, followersCount: String, followingCount: String) {
        
        self.userName = userName
        self.handler = handler
        self.statusCount = statusCount
        self.profileImgUrl = profileImgUrl
        self.followersCount = followersCount
        self.followingCount = followingCount
    }
}
