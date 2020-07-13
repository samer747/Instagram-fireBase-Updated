//
//  FirebaseUtils.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/16/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import Foundation
import Firebase

extension Database{
    static func fetchUserWithID(uid: String, completion: @escaping(User) -> () ){
        Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard  let dic = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dic: dic)
            completion(user)
            
        }) { (err) in
            print("Error in fetching user data :",err)
        }
    }
}
