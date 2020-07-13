//
//  HomePostCell.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/25/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func commentTapDid(post: Post)
    func likeTapDid(for cel: HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    
    var delegate : HomePostCellDelegate?
    
    var post: Post? {
        didSet{
            guard let post = post else {return}
            let imageURL = post.imageUrl
            postImage.loadImage(url: imageURL)
            userLable.text = post.user.username
            let imageUrl = post.user.profileImageUrl
            sProfileImage.loadImage(url: imageUrl)
            setupAttText()
            if post.hasLiked == true {
                like.setImage(#imageLiteral(resourceName: "likeSelected"), for: .normal)
            }else{
                like.setImage(#imageLiteral(resourceName: "likeUnselected"), for: .normal)
            }
        }
    }
    fileprivate func setupAttText()
    {
        guard let post = self.post else { return }
        
        let att = NSMutableAttributedString(string: "\(post.user.username) ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        att.append(NSAttributedString(string: post.caption, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        att.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
        addedTime.text = post.creationDate.timeAgo()
        caption.attributedText = att
    }
    //MARK: -------------- Add added Time Lable -------------------
    let addedTime : UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .init(r: 128, g: 128, b: 128)
        l.numberOfLines = 1
        return l
    }()
    //MARK: -------------- Add caption lable -------------------
    let caption : UILabel = {
        let c = UILabel()
        c.numberOfLines = 2
        c.backgroundColor = .white
        return c
    }()
    //MARK: -------------- Add TheButtons Under The Image -------------------
    lazy var like : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "likeUnselected"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
        return btn
    }()
    lazy var com : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "likeUnselected"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.addTarget(self, action: #selector(handleCommentButton), for: .touchUpInside)
        return btn
    }()
    lazy var share : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "likeUnselected"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.addTarget(self, action: #selector(handleShareButton), for: .touchUpInside)
        return btn
    }()
    lazy var save : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "likeSelected"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return btn
    }()
    //MARK: -------------- Add smallProfileImage -------------------
    let sProfileImage : CustomImageView = {
        let s = CustomImageView()
        s.clipsToBounds = true
        s.layer.cornerRadius = 20
        return s
    }()
    //MARK: -------------- Add UserName Lable -------------------
    let userLable : UILabel = {
        let u = UILabel()
        u.font = UIFont.boldSystemFont(ofSize: 14)
        return u
    }()
    //MARK: -------------- Add postSettingButton -------------------
    let postSettingBtn : UIButton = {
        let p = UIButton()
        p.setTitle("•••", for: .normal)
        p.setTitleColor(.black, for: .normal)
        return p
    }()
    //MARK: -------------- Add PostImage -------------------
    let postImage : CustomImageView = {
        let x = CustomImageView()
        x.backgroundColor = .black
        x.clipsToBounds = true
        x.contentMode = .scaleAspectFill
        return x
    }()
    
    //MARK: -------------- viewDidLoad -------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    //MARK: -------------- setup LayOuts -------------------
    fileprivate func setupLayout()
    {
        
        addSubview(postImage)
        addSubview(sProfileImage)
        addSubview(postSettingBtn)
        addSubview(userLable)
        addSubview(save)
        addSubview(caption)
        addSubview(addedTime)
        
        
        postImage.anchor(top: topAnchor, paddingTop: 60, bottom: nil, paddingBottom: 0, leading: leadingAnchor, paddingLeft: 0, trailing: trailingAnchor, paddingRight: 0, width: 0, height: 300)
        sProfileImage.anchor(top: topAnchor, paddingTop: 10, bottom: postImage.topAnchor, paddingBottom: -10, leading: leadingAnchor, paddingLeft: 7, trailing: nil, paddingRight: 0, width: 40, height: 0)
        postSettingBtn.anchor(top: topAnchor, paddingTop: 10, bottom: postImage.topAnchor, paddingBottom: -10, leading: nil, paddingLeft: 0, trailing: trailingAnchor, paddingRight: -5, width: 30, height: 0)
        userLable.anchor(top: topAnchor, paddingTop: 10, bottom: postImage.topAnchor, paddingBottom: -10, leading: sProfileImage.trailingAnchor, paddingLeft: 8, trailing: postSettingBtn.leadingAnchor, paddingRight: 8, width: 0, height: 0)
        save.anchor(top: postImage.bottomAnchor, paddingTop: 7, bottom: nil, paddingBottom: 0, leading: nil, paddingLeft: 0, trailing: trailingAnchor, paddingRight: -7, width: 30, height: 30)
        
        setupStack()
        
        caption.anchor(top: like.bottomAnchor, paddingTop: 5, bottom: addedTime.topAnchor, paddingBottom: -2, leading: leadingAnchor, paddingLeft: 8, trailing: trailingAnchor, paddingRight: -8, width: 0, height: 0)
        addedTime.anchor(top: nil, paddingTop: 0, bottom: bottomAnchor, paddingBottom: -7, leading: leadingAnchor, paddingLeft: 8, trailing: trailingAnchor, paddingRight: -10, width: 0, height: 0)
        
        
    }
    fileprivate func setupStack()
    {
        let stack = UIStackView(arrangedSubviews: [like,com,share])
        stack.distribution = .fillEqually
        stack.spacing = 5
        addSubview(stack)
        
        stack.anchor(top: postImage.bottomAnchor, paddingTop: 7, bottom: nil, paddingBottom: 0, leading: leadingAnchor, paddingLeft: 7, trailing: nil, paddingRight: 0, width: 100, height: 30)
    }
    //MARK: -------- Handle stack Buttons ----------
    @objc fileprivate func handleLikeButton(){
        delegate?.likeTapDid(for: self)
    }
    @objc fileprivate func handleCommentButton(){
        guard let commentPost = self.post else {return}
        delegate?.commentTapDid(post: commentPost)
    }
    @objc fileprivate func handleShareButton(){
        print("Share pressed")
    }
    @objc fileprivate func handleSaveButton(){
        print("Save Pressed")
    }
    //MARK: -------- method for some errors ----------
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
