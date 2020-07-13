//
//  CommentCell.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 7/7/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit
import Firebase

class CommentCell: UICollectionViewCell {
    
    var comment : Comment?{
        didSet{
            guard let comment = comment else { return }
            
            userPic.loadImage(url: comment.user.profileImageUrl)
            
            let attText = NSMutableAttributedString(string: ((comment.user.username) + " "), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attText.append(NSAttributedString(string: comment.text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            commentTextField.attributedText = attText  
        }
    }
    let commentTextField : UITextView = {
        let l = UITextView()
        l.isScrollEnabled = false
        l.isEditable = false
        return l
    }()
    let userPic : CustomImageView = {
        let x = CustomImageView()
        x.layer.cornerRadius = 15
        x.clipsToBounds = true
        x.contentMode = .scaleAspectFill
        return x
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayouts()
        
    }
    fileprivate func setupLayouts(){
        self.addSubview(commentTextField)
        commentTextField.anchor(top: self.topAnchor, paddingTop: 0, bottom: self.bottomAnchor, paddingBottom: 0, leading: self.leadingAnchor, paddingLeft: 45, trailing: self.trailingAnchor, paddingRight: -5, width: 0, height: 0)
        
        self.addSubview(userPic)
        userPic.anchor(top: self.topAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, leading: self.leadingAnchor, paddingLeft: 10, trailing: nil, paddingRight: 0, width: 30, height: 30)
    }
    fileprivate func fetchCommentPhoto(){
         guard let comment = comment else { return }
        guard let url = URL(string: comment.user.profileImageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to load image from db:", error)
                return
            }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.userPic.image = photoImage
            }
        }.resume()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
