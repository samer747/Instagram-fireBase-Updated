//
//  HomeViewController.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/25/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController : UICollectionViewController , UICollectionViewDelegateFlowLayout , HomePostCellDelegate {
    
    //MARK: ------------------- view didload -----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: SharePhotoController.notificationShareEndName, object: nil)
        
        collectionView.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 240/255, green: 240/255, blue: 240/255, alpha: 1))
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: "CellId2")
        
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshController
        
        setupNavBarItems()
        handleRefresh()
        
    }
    //MARK: ---------------- Handle Refreshing ------------------
    @objc fileprivate func handleRefresh(){
        posts.removeAll()
        collectionView.reloadData()
        fetchPosts()
        fetchFollowing()
    }
    //MARK: ---------------- fetching posts photos ------------------
    var posts = [Post]()
    
    fileprivate func fetchFollowing(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("Following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else {return}
            
            userIdsDictionary.forEach { (key , value) in
                Database.fetchUserWithID(uid: key) { (user) in
                    self.fetchingPostWithUser(user: user)
                }
            }
        }) { (err) in
            print("Error in fetching followings",err)
        }
    }
    
    fileprivate func fetchPosts()
    {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithID(uid: uid) { (user) in
            self.fetchingPostWithUser(user: user)
        }
    }
    fileprivate func fetchingPostWithUser(user: User)
    {
        let ref = Database.database().reference().child("Posts").child(user.uid)
        ref.queryOrdered(byChild: "CreationDate").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            
            dictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String: Any] else{return}
                var post = Post(user: user, dictionary: dictionary)
                post.postId = key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("Likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let x = snapshot.value as? Int , x == 1 {
                        post.hasLiked = true
                    }
                    else{
                        post.hasLiked = false
                    }
                    post.postId = key
                    self.posts.append(post)
                    self.posts.sort (by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView.reloadData()
                    
                }, withCancel: { (err) in
                    print("Error in geting hasLiked Value")
                })
            }
            
        }) { (err) in
            print("Error in fetching posts photos : ",err)
        }
    }
    
    
    //MARK: ------------------- cells setup -----------------------
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width , height: 464)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId2", for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.row]
        
        cell.delegate = self
        
        return cell
    }
    
    //MARK: ------------------- navBar Items  -----------------------
    fileprivate func setupNavBarItems(){
        let x = UIImageView()
        x.contentMode = .scaleAspectFit
        x.image = #imageLiteral(resourceName: "instagram-logo")
        navigationItem.titleView = x
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: resizeImage(image: #imageLiteral(resourceName: "add_image_button"), targetSize: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action:nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: resizeImage(image: #imageLiteral(resourceName: "add_image_button"), targetSize: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action:#selector(handleCameraButton))
        
        navigationItem.rightBarButtonItem?.tintColor = .black
        
    }
    @objc func handleCameraButton(){
        let cameraController = CameraController()
        cameraController.modalPresentationStyle = .fullScreen
        present(cameraController, animated: true, completion: nil)
    }
    //MARK: ------------------- resize image func -----------------------
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height *      widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    //MARK: ------------------- Protocol Methods -----------------------
    func commentTapDid(post: Post) {
        let commentViewController = CommentViewController(collectionViewLayout: UICollectionViewFlowLayout())
        commentViewController.post = post
        navigationController?.pushViewController(commentViewController, animated: true)
    }
    func likeTapDid(for cel: HomePostCell) {
        guard let indexPath = collectionView.indexPath(for: cel) else {return}
        var post = self.posts[indexPath.item]
        guard let postId = post.postId else {return}
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [uid: post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("Likes").child(postId).updateChildValues(values) { (err, _) in
            //faild
            if let err = err {
                print("Error in Update like values :" ,err)
                return
            }
            //SuccessFully
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.item] = post
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}

