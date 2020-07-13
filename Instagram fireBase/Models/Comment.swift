//
//  Comment.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 7/7/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import Foundation

struct Comment {
    let user : User
    let text : String
    let uid : String
    let creationDate : String
    
    init(user: User,Dictionary: [String: Any]) {
        text = Dictionary["Text"] as? String ?? ""
        uid = Dictionary["uid"] as? String ?? ""
        creationDate = Dictionary["CreationDate"] as? String ?? ""
        self.user = user
    }
}
