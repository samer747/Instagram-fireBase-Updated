//
//  UserProfileTap.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/14/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit
import Firebase

class UserProfileTab: UICollectionViewController , UICollectionViewDelegateFlowLayout ,UserProfileHeaderDelegate {
    
    var userId : String?
    var isGridView = true
    
    //MARK: ---------------- ViewDidLoad --------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshController
        
        collectionView.backgroundColor = .white
        
        fetchUser()
        setupSettingButton()
        ///------de 34an tsgl el clas el mot7km bel header w el cells w trpoto bel Identifier-------
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader  , withReuseIdentifier: "headerid")
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: "CellID")
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: "cellId")
        
    }
    //MARK: ---------------- Handle Refresh ------------------
    @objc fileprivate func handleRefresh(){
        posts.removeAll()
        collectionView.reloadData()
        fetchUser()
    }
    //MARK: ---------------- fetching posts photos ------------------
    var posts = [Post]()
    var isPagingFinnished = false
    fileprivate func pagenatePosts(){
        guard let user = self.user else {return}
        let ref = Database.database().reference().child("Posts").child(user.uid)
        
        self.collectionView.refreshControl?.endRefreshing()
       // var query = ref.queryOrdered(byChild: "CreationDate")
        var query = ref.queryOrderedByKey()
        
        if posts.count > 0 {
          //  query = ref.queryOrderedByValue().queryEnding(atValue: posts.last?.creationDate)
            query = ref.queryOrderedByKey().queryEnding(atValue: posts.last?.postId)
            
        }
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard var allOBjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            allOBjects.reverse()
            
            if allOBjects.count < 4 {
                self.isPagingFinnished = true
            }
            if self.posts.count > 0 && allOBjects.count > 0{
                allOBjects.removeFirst()
            }
            allOBjects.forEach({ (snapshot) in
                guard let dic = snapshot.value as? [String: Any] else {return}
                var post = Post(user: user, dictionary: dic)
                post.postId = snapshot.key
                self.posts.append(post)
            })
            
            self.collectionView.reloadData()
        }) { (err) in
            print("Error : ",err)
        }
    }
    fileprivate func fetchPhotos()
    {
        guard let uid = self.user?.uid else {return}
        let ref = Database.database().reference().child("Posts").child(uid)
        ref.queryOrdered(byChild: "CreationDate").observe(.childAdded , with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            guard let user = self.user else {return}
            let post = Post(user: user, dictionary: dictionaries)
            self.posts.insert(post, at: 0)
            
            self.collectionView.reloadData()
        }) { (err) in
            print("Error in fetching posts photos : ",err)
        }
    }
    //MARK: ----------- Setup settings button ---------
    func setupSettingButton(){
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: resizeImage(image: #imageLiteral(resourceName: "add_image_button"), targetSize: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(settingButtonDidPressed))
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBackBtn))
        
    }
    @objc func handleBackBtn(){
        gridButtonPressed()
        collectionView.scrollsToTop = true
    }
    @objc func settingButtonDidPressed()
    {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "LogOut", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let signInController = SignInController()
                let navgation = UINavigationController(rootViewController: signInController)
                navgation.modalPresentationStyle = .fullScreen
                self.present(navgation, animated: true, completion: nil)
            } catch let err
            {
                print("error :",err)
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true , completion: nil)
        
    }
    //MARK: ---------------- Cells Setup -------------------
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView{
        let size  = (view.frame.width - 2) / 3
        return CGSize(width: size, height: size)
        }else{
            return CGSize(width: view.frame.width, height: 555)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isGridView {
            listButtonPressed()
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //pagenate Call
        if indexPath.item == self.posts.count - 1 && !isPagingFinnished {
            
            pagenatePosts()
            
        }
        
        if isGridView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! UserProfilePhotoCell
        cell.post = posts[indexPath.item]
        return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
            return cell
        }
    }
    
    //MARK: ---------------- Header Setup --------------------
    ///Identifier for the header controller
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerid", for: indexPath) as! UserProfileHeader
        header.user = self.user
        header.delegate = self
        
        return header
    }
    ///Resize Func for the Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 400)
    }
    
    //MARK: -------------- Fetch UserName ---------------
    var user: User?
    fileprivate func fetchUser()
    {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
       
        Database.fetchUserWithID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.navigationItem.leftBarButtonItem?.tintColor = .black
            self.collectionView.reloadData()

            self.pagenatePosts()
        }
    }
    //MARK: ------------ Protocol Methods -------------
    func unfollowPressed(for val: Int) {
        if val == 1 {//UnFollowPressed
        var userName : String?
        Database.fetchUserWithID(uid: userId ?? "User ") { (user) in
           userName = user.username
            
            let alert = UIAlertController(title: "You UnFollowed \(userName ?? "This User") Successfully" , message: nil, preferredStyle: .actionSheet )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true) {
                self.collectionView.reloadData()
            }
        }
        }else{//FollowPressed
            self.collectionView.reloadData()
        }
    }
    func gridButtonPressed() {
        isGridView = true
        collectionView.reloadData()
    }
    
    func listButtonPressed() {
        isGridView = false
        collectionView.reloadData()
    }
    
    
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
}



