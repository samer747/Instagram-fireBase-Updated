//
//  PhotoSelectorCell.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/19/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
    let imageI : UIImageView = {
       let i = UIImageView()
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        i.backgroundColor = .lightGray
        return i
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageI)
        imageI.anchor(top: topAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, leading: leadingAnchor, paddingLeft: 0, trailing: trailingAnchor, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
