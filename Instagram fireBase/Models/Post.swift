//
//  Posts.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/24/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import Foundation

struct Post {
    
    var postId : String?
    var hasLiked : Bool
    
    let imageUrl: String
    let user : User
    let caption : String
    let creationDate: Date
    
    
    init(user: User,dictionary: [String: Any]) {
        self.imageUrl = dictionary["ImageUrl"] as? String ?? ""
        self.user = user
        self.caption = dictionary["Caption"] as? String ?? ""
        let secondsFrom1970 = dictionary["CreationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        self.hasLiked = false
    }
}
