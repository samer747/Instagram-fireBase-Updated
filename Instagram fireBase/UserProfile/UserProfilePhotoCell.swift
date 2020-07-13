//
//  UserProfilePhotoCell.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/24/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    var post: Post? {
        didSet{
            
            guard let imageURL = post?.imageUrl else {return}
            photoImageView.loadImage(url: imageURL)
            
        }
    }
    
    
    let photoImageView: CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, leading: leadingAnchor, paddingLeft: 0, trailing: trailingAnchor, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
