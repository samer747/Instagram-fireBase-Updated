//
//  UserProfileHeader.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/14/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func unfollowPressed(for val: Int)
    func gridButtonPressed()
    func listButtonPressed()
}

class UserProfileHeader: UICollectionViewCell {
    
    var delegate : UserProfileHeaderDelegate?
    
    //MARK: --------- fetching user data from profille tap class -----------
       var user : User?{ ///the user with the data
           didSet{
            
            guard let curUser = user else {return}
            
            let profileImageUrl = curUser.profileImageUrl
            profileImageView.loadImage(url: profileImageUrl)
            usernameLable.text = curUser.username
            setupEditeFollowButton()
            //posts lable Text
            let ref = Database.database().reference().child("Posts").child(curUser.uid)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let attText = NSMutableAttributedString(string: String(snapshot.childrenCount), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
                attText.append(NSAttributedString(string: "\nPosts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12) , NSAttributedString.Key.foregroundColor : UIColor.black]))
                self.postsLable.attributedText = attText
            }) { (err) in
                print("error calc posts: ",err)
            }
            //followers
            let reff = Database.database().reference().child("Followers").child(curUser.uid)
            reff.observeSingleEvent(of: .value, with: { (snapshot) in
                let attText = NSMutableAttributedString(string: String(snapshot.childrenCount), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
                attText.append(NSAttributedString(string: "\nFollowers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12) , NSAttributedString.Key.foregroundColor : UIColor.black]))
                self.followersLable.attributedText = attText
            }) { (err) in
                print("error calc posts: ",err)
            }
            //following
            let refff = Database.database().reference().child("Following").child(curUser.uid)
            refff.observeSingleEvent(of: .value, with: { (snapshot) in
                let attText = NSMutableAttributedString(string: String(snapshot.childrenCount), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
                attText.append(NSAttributedString(string: "\nFollowing", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12) , NSAttributedString.Key.foregroundColor : UIColor.black]))
                self.followingLable.attributedText = attText
            }) { (err) in
                print("error calc posts: ",err)
            }
           }
       }
    //MARK: --------- Add Highlights stack -----------
    let onetext : UILabel = {
       let v = UILabel()
        v.text = "New"
        v.font = UIFont.systemFont(ofSize: 12)
        v.textColor = .black
        return v
    }()
    let twotext : UILabel = {
       let v = UILabel()
        v.text = "Highlights"
        v.font = UIFont.systemFont(ofSize: 12)
        v.textColor = .black
        return v
    }()
    let threetext : UILabel = {
       let v = UILabel()
        v.text = "."
        v.font = UIFont.systemFont(ofSize: 12)
        v.textColor = .black
        return v
    }()
    let fourtext : UILabel = {
       let v = UILabel()
        v.text = "."
        v.font = UIFont.systemFont(ofSize: 12)
        v.textColor = .black
        return v
    }()
    
    let oneView : UIImageView = {
       let v = UIImageView()
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 30
        v.layer.borderColor = .init(srgbRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        v.layer.borderWidth = 0.5
        v.backgroundColor = .red
        return v
    }()
    let twoView : UIImageView = {
       let v = UIImageView()
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 30
        v.layer.borderColor = .init(srgbRed: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        v.layer.borderWidth = 2
        v.backgroundColor = .yellow
        return v
    }()
    let threeView : UIImageView = {
       let v = UIImageView()
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 30
        v.layer.borderColor = .init(srgbRed: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        v.layer.borderWidth = 2
        v.backgroundColor = .systemGray3
        return v
    }()
    let fourView : UIImageView = {
       let v = UIImageView()
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 30
        v.layer.borderColor = .init(srgbRed: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        v.layer.borderWidth = 2
        v.backgroundColor = .systemGray
        return v
    }()
    //MARK: --------- Add Edite Profile Button -----------
    lazy var  editeProfileButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = CGColor(srgbRed: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleEditeFollowButton), for: .touchUpInside)
        return btn
    }()
    //MARK: ------------ Add usernamer lable and bio -------------
    let usernameLable : UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        lable.font = UIFont.boldSystemFont(ofSize: 15)
        return lable
    }()
    let bioText : UILabel = {
        let txt = UILabel()
        txt.text = "VolleyBall Player * #10\nCS SH.A *\nJr. IOS Developer "
        txt.font = UIFont.systemFont(ofSize: 14)
        txt.numberOfLines = 0
        txt.textColor = .darkText
        return txt
    }()
    let wepTxt : UILabel = {
        let txt = UILabel()
        txt.text = "tellonym.me/samerms"
        txt.font = UIFont.systemFont(ofSize: 14)
        txt.numberOfLines = 1
        txt.textColor = .systemBlue
        return txt
    }()
    //MARK: ------------ add Three lables for account status -------------
    
    
    let postsLable : UILabel = {
        let lable = UILabel()
        let attText = NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
        attText.append(NSAttributedString(string: "Posts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12) , NSAttributedString.Key.foregroundColor : UIColor.black]))
        lable.textAlignment = .center
        lable.numberOfLines = 2
        return lable
    }()
    let followersLable : UILabel = {
        let lable = UILabel()
        let attText = NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
        attText.append(NSAttributedString(string: "Followers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12) , NSAttributedString.Key.foregroundColor : UIColor.black]))
        
        lable.attributedText = attText
        lable.textAlignment = .center
        lable.numberOfLines = 2
        return lable
    }()
    let followingLable : UILabel = {
        let lable = UILabel()
        let attText = NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
        attText.append(NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12) , NSAttributedString.Key.foregroundColor : UIColor.black]))
        
        lable.attributedText = attText
        lable.textAlignment = .center
        lable.numberOfLines = 2
        return lable
    }()
    
    //MARK: ------------ add ThreeButtons -------------
    lazy var gridButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("G", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleGridViewButton), for: .touchUpInside)
        return button
    }()
    @objc fileprivate func handleGridViewButton(){
        listButton.setTitleColor(.black, for: .normal)
        gridButton.setTitleColor(.systemBlue, for: .normal)
        delegate?.gridButtonPressed()
    }
    lazy var listButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("L", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleListViewButton), for: .touchUpInside)
        return button
    }()
    @objc fileprivate func handleListViewButton(){
        gridButton.setTitleColor(.black, for: .normal)
        listButton.setTitleColor(.systemBlue, for: .normal)
        delegate?.listButtonPressed()
    }
    let bookMarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("B", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        return button
    }()
    
    
    //MARK: ----------- add Profile image View -------------
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .brown
        return iv
    }()
    //MARK: ----------- Header DidLoad -------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupProfileImageView()
        setupStatusStack()
        setupUserNameLable()
        setupBioText()
        setupBotStack()
        setupEditeProfileButton()
        setupHighLightsStack()
        setupHighTexts()
      
        
    }
    //MARK: ------------ Setup highlights texts -----------------
    func setupHighTexts(){
        
        addSubview(onetext)
        addSubview(twotext)
        addSubview(threetext)
        addSubview(fourtext)
        
        onetext.translatesAutoresizingMaskIntoConstraints = false
        twotext.translatesAutoresizingMaskIntoConstraints = false
        threetext.translatesAutoresizingMaskIntoConstraints = false
        fourtext.translatesAutoresizingMaskIntoConstraints = false
        
        onetext.centerXAnchor.constraint(equalTo: oneView.centerXAnchor, constant: 0).isActive = true
        onetext.centerYAnchor.constraint(equalTo: oneView.centerYAnchor, constant: 43).isActive = true
        
        twotext.centerXAnchor.constraint(equalTo: twoView.centerXAnchor, constant: 0).isActive = true
        twotext.centerYAnchor.constraint(equalTo: twoView.centerYAnchor, constant: 43).isActive = true
        
        threetext.centerXAnchor.constraint(equalTo: threeView.centerXAnchor, constant: 0).isActive = true
        threetext.centerYAnchor.constraint(equalTo: threeView.centerYAnchor, constant: 43).isActive = true
        
        fourtext.centerXAnchor.constraint(equalTo: fourView.centerXAnchor, constant: 0).isActive = true
        fourtext.centerYAnchor.constraint(equalTo: fourView.centerYAnchor, constant: 43).isActive = true
    }
    //MARK: ------------ Setup highlights stack -----------------
    func setupHighLightsStack(){
        
        let stack : UIStackView = UIStackView(arrangedSubviews: [oneView,twoView,threeView,fourView])
        addSubview(stack)
        stack.distribution = .fillEqually
        stack.spacing = 30
        stack.anchor(top: nil, paddingTop: 0, bottom: listButton.topAnchor, paddingBottom: -30, leading: leadingAnchor, paddingLeft: 15, trailing: trailingAnchor, paddingRight: -30, width: 0, height: 60)
    }
    //MARK: ------------ Setup Edite Profile Button -----------------
    func setupEditeProfileButton(){
       addSubview(editeProfileButton)
        editeProfileButton.anchor(top: wepTxt.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, leading: leadingAnchor, paddingLeft: 20, trailing: trailingAnchor, paddingRight: -20, width: 0, height: 30)
    }
    fileprivate func setupEditeFollowButton(){
        guard let curUser = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        if curUser == userId {
            editeProfileButton.setTitle("Edite Profile", for: .normal)
        }
        else{ Database.database().reference().child("Following").child(curUser).child(userId).observeSingleEvent(of: .value) { (snapshot) in
            
            if let x = snapshot.value as? Int , x == 1 {
                self.editeProfileButton.setTitle("Following", for: .normal)
                self.editeProfileButton.backgroundColor = .white
                self.editeProfileButton.setTitleColor(.black, for: .normal)
                self.editeProfileButton.layer.borderColor = CGColor(srgbRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            }else{
                self.editeProfileButton.setTitle("Follow", for: .normal)
                self.editeProfileButton.backgroundColor = .systemBlue
                self.editeProfileButton.layer.borderColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1).cgColor
                self.editeProfileButton.setTitleColor(.white, for: .normal)
                 }
            }
        }
    }
    @objc func handleEditeFollowButton(){
        guard let curUser = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        if curUser == userId {
            print("Edite Profile Button Pressed")
        }
        else{
            
            if editeProfileButton.titleLabel?.text == "Following"{
                //Unfollow
                delegate?.unfollowPressed(for: 1)
                Database.database().reference().child("Following").child(curUser).child(userId).removeValue { (err, ref) in
                    if let err = err {
                        print("Error in UnFollowing",err)
                        return
                    }
                    Database.database().reference().child("Followers").child(userId).child(curUser).removeValue { (err, ref) in
                        if let err = err {
                            print("Error in UnFollowing",err)
                            return
                        }
                    }
                }
            }else{
                // will follow
                delegate?.unfollowPressed(for: 0)
                let ref = Database.database().reference().child("Following").child(curUser)
                ref.updateChildValues([userId: 1]) { (err, ref) in
                    if let err = err {
                        print("Error in following: ",err)
                        return
                    }
                    let ref = Database.database().reference().child("Followers").child(userId)
                    ref.updateChildValues([curUser: 1]) { (err, ref) in
                        if let err = err {
                            print("Error in following: ",err)
                            return
                        }
                    }
                }
            }
            setupEditeFollowButton()
        }
    }
    //MARK: ------------ Setup Status stack -----------------
    
    func setupStatusStack() {
        let statusStack = UIStackView(arrangedSubviews: [postsLable,followersLable,followingLable])
        addSubview(statusStack)
        statusStack.distribution = .fillEqually
        statusStack.axis = .horizontal
        statusStack.anchor(top: topAnchor, paddingTop: 33, bottom: nil, paddingBottom: 0, leading: profileImageView.trailingAnchor, paddingLeft: 20, trailing: trailingAnchor, paddingRight: -20, width: 0, height: 40)
        
    }
    
    //MARK: ------------ Setup UserName Lable -----------------
    func setupUserNameLable(){
       addSubview(usernameLable)
        usernameLable.anchor(top: profileImageView.bottomAnchor, paddingTop: 12, bottom: nil, paddingBottom: 0, leading: leadingAnchor, paddingLeft: 12, trailing: trailingAnchor, paddingRight: 12, width: 0, height: 16)
       
    }
    func setupBioText(){
        addSubview(bioText)
        bioText.anchor(top: usernameLable.bottomAnchor, paddingTop: -5, bottom: nil, paddingBottom: 0, leading: leadingAnchor, paddingLeft: 12, trailing: trailingAnchor, paddingRight: 12, width: 0, height: 60)
        addSubview(wepTxt)
        wepTxt.anchor(top: bioText.bottomAnchor, paddingTop: -5, bottom: nil, paddingBottom: 0, leading: leadingAnchor, paddingLeft: 12, trailing: trailingAnchor, paddingRight: 12, width: 0, height: 13)
    }
    //MARK: ------------ Setup Header Bottom Buttons Stack -----------------
    fileprivate func setupBotStack (){
        let viewX = UIView()
        addSubview(viewX)
        viewX.anchor(top: nil, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, leading: leadingAnchor, paddingLeft: -1, trailing: trailingAnchor, paddingRight: 1, width: 0, height: 40)
        viewX.layer.borderColor = CGColor(srgbRed: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        viewX.layer.borderWidth = 2
        viewX.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 224/255, green: 224/255, blue: 224/255, alpha: 1))
        
        let stack = UIStackView(arrangedSubviews: [gridButton,listButton,bookMarkButton])
        viewX.addSubview(stack)
        
        stack.anchor(top: viewX.topAnchor, paddingTop: 0, bottom: viewX.bottomAnchor, paddingBottom: 0, leading: viewX.leadingAnchor, paddingLeft: 0, trailing: viewX.trailingAnchor, paddingRight: 0, width: 0, height: 0)
        stack.spacing = 0
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        
        
    }
    //MARK: ------- setup Profile Image View --------
    fileprivate func setupProfileImageView()
    {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, paddingTop: 18, bottom: nil, paddingBottom: 0, leading: leadingAnchor, paddingLeft: 18, trailing: nil, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 80/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
