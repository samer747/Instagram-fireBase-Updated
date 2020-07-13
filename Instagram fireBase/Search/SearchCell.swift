//
//  SearchCell.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/30/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
    var users : User? {
        didSet{
            guard let users = users else { return }
            profileImage.loadImage(url: users.profileImageUrl )
            textLable.text = users.username
            postsLable.text = "\(users.numOfPosts!) Posts"
        }
    }
    //MARK: ----------------- ADD CellImage ---------------------
    let profileImage : CustomImageView = {
       let i = CustomImageView()
        i.clipsToBounds = true
        i.layer.cornerRadius = 30
        i.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        i.layer.borderWidth = 1
        return i
    }()
    //MARK: ----------------- Add THE Texts ---------------------"
    let textLable : UILabel = {
       let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 14)
        l.numberOfLines = 1
        return l
    }()
    let postsLable : UILabel = {
       let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13)
        l.text = "text"
        l.textColor = UIColor.lightGray
        l.numberOfLines = 1
        return l
    }()
    
    //MARK: ----------------- viewDidLoad ---------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupLayouts()
    }
    //MARK: ----------------- setupLAYOUTS ---------------------
    fileprivate func setupLayouts(){
        addSubview(profileImage)
        addSubview(textLable)
        addSubview(postsLable)
        
        profileImage.anchor(top: topAnchor, paddingTop: 10, bottom: bottomAnchor, paddingBottom: -10, leading: leadingAnchor, paddingLeft: 10, trailing: nil, paddingRight: 0, width: 60, height: 0)
        
        
        textLable.anchor(top: topAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, leading: profileImage.trailingAnchor, paddingLeft: 10, trailing: trailingAnchor, paddingRight: 10, width: 0, height: 20)
        postsLable.anchor(top: nil, paddingTop: 0, bottom: bottomAnchor, paddingBottom: -20, leading: profileImage.trailingAnchor, paddingLeft: 10, trailing: trailingAnchor, paddingRight: 10, width: 0, height: 20)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
