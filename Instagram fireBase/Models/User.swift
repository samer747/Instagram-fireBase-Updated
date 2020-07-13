//
//  User.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/28/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import Foundation

struct User {
    
    let uid : String
    let username : String
    let profileImageUrl : String
    var numOfPosts : Int?
    
    init(uid: String ,dic : [String: Any]) {
        
        username = dic["UserName"] as? String ?? "a7a"
        profileImageUrl = dic["imageURL"] as? String ?? ""
        self.uid = uid
    }
    
}
