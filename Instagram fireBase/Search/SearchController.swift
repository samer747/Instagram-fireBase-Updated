//
//  SearchController.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/30/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit
import Firebase

class SearchController: UICollectionViewController ,UICollectionViewDelegateFlowLayout ,UISearchBarDelegate{
    
    //MARK: - Variables
    var filteredUsers = [User]()
    var users = [User]()
    //MARK: - searchBar
    lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.delegate = self
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        }else {
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        
        
        self.collectionView.reloadData()
    }
    //MARK: -------------- viewDIDLoad -----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 240/255, green: 240/255, blue: 240/255, alpha: 1))
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: "CellID")
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        
        setupNavBarItems()
        fetchUsers()

        self.collectionView.reloadData()
    }
    
    //MARK: ----------- fetch USERS -------------
    private func fetchUsers(){
        Database.database().reference().child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach { (key , value) in
                if key == Auth.auth().currentUser?.uid { //34an el  user ely fate7 my4of4 nfso fe el searched users
                    return
                }
                guard let userDic = value as? [String: Any] else {return}
                
                var user = User(uid: key, dic: userDic)
                Database.database().reference().child("Posts").child(user.uid).observe(.value) { (snapshot) in
                    user.numOfPosts = Int(snapshot.childrenCount)
                    self.users.append(user)
                    self.users.sort { (u1, u2) -> Bool in
                        return u1.username.compare(u2.username) == .orderedAscending
                    }
                    self.filteredUsers = self.users
                    self.collectionView.reloadData()
                }
                
            }
            
            
        }) { (err) in
            print("Error in fetching users for searchTap : ",err)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.isHidden = false
    }
    //MARK: -------------- CELL SETUP -----------------
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! SearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder() ///hidding the keyboard
        
        let user = filteredUsers[indexPath.row]
        
        let userProfileController = UserProfileTab(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    
    //MARK: ------------------- navBar Items  -----------------------
    fileprivate func setupNavBarItems(){
        let navBar = navigationController?.navigationBar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, paddingTop: 0, bottom: navBar?.bottomAnchor, paddingBottom: 0, leading: navBar?.leadingAnchor, paddingLeft: 8, trailing: navBar?.trailingAnchor, paddingRight: -8, width: 0, height: 0)
    }
}
