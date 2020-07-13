//
//  CommentViewController.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 7/7/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout , CommentDelegate{
    
        
    
    
    
    var post : Post?
    //MARK:----------- textField and PostButton -------------
    
    //MARK:   ----------- ContainerView -------------
    lazy var containerView : UIView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentContainerView = CommentContainerView(frame: frame)
        commentContainerView.delegate = self
        return commentContainerView
    }()
    //MARK:----------- ViewDidLoad -------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mlhom4 lazma 34an kolo = 0 bs momkn t7taghom
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) ///da by7ded el content ykon a5ro fo2 el container bta3t el text fireld
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)/// da 34an el scroold indecator byd5ol4 t7t el post button
        collectionView.backgroundColor = .white
        navigationItem.title = "Comments"
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView?.keyboardDismissMode = .interactive
        collectionView.alwaysBounceVertical = true
        
        fetchingComments()
    }
    //MARK:----------- when appear and disappear -------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = false
    }
    //MARK:----------- Cell Setup -------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)

        let height =  max(40, estimatedSize.height)
        let size  = CGSize(width: view.frame.width, height: height)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! CommentCell
        cell.comment = self.comments[indexPath.item]
        return cell
    }
    //MARK:----------- bottom Input View -------------
    override var inputAccessoryView: UIView?{
        get{
            
            return containerView
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    //MARK:----------- fetching comments -------------
    var comments = [Comment]()
    fileprivate func fetchingComments(){
        
        guard let postId = self.post?.postId else {return}
        let ref = Database.database().reference().child("Comments").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            
            guard let dic = snapshot.value as? [String: Any] else { return }
            
            guard let uid = dic["uid"] else {return}
            Database.fetchUserWithID(uid: uid as! String) { (user) in
                let comment = Comment(user: user, Dictionary: dic)
                self.comments.append(comment)
                self.collectionView.reloadData()
            }
        }) { (err) in
            print("Error in Fetching Comments: ",err)
        }
    }
    //MARK:----------- Post Button Handle -------------
     func commentDidPressed(for comment: String) {
        guard let postId = self.post?.postId else { return }
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let values = ["Text": comment,"CreationDate": Date().timeIntervalSince1970 ,"uid": uid] as [String : Any]
        
        
        Database.database().reference().child("Comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            if let err = err {
                print(err)
                return
            }
            
        }
    }

    
    
}
