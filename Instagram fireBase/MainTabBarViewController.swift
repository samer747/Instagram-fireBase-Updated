//
//  TabViewController.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/14/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarViewController : UITabBarController,UITabBarControllerDelegate{
    
    
    
    lazy var profileImageSelected : CustomImageView = {
        let image = CustomImageView()
        image.layer.borderColor = .init(srgbRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        image.layer.borderWidth = 2
        image.layer.cornerRadius = 10
        
        return image
    }()
    lazy var profileImageUnSelected : CustomImageView = {
        let image = CustomImageView()
        image.layer.cornerRadius = 10
        return image
    }()
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: photoSelectorController)
            navController.modalPresentationStyle = .fullScreen
            
            present(navController,animated: true,completion: nil)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil
        {
            DispatchQueue.main.async {
                
                
                let signInController = SignInController()
                let navgation = UINavigationController(rootViewController: signInController)
                navgation.modalPresentationStyle = .fullScreen
                self.present(navgation, animated: true, completion: nil)
            }
            return
        }
        setupProfileImage()
        setupViewControllers()
    }
    fileprivate func setupProfileImage(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.fetchUserWithID(uid: uid) { (user) in
            self.profileImageSelected.loadImage(url: user.profileImageUrl)
            self.profileImageUnSelected.loadImage(url: user.profileImageUrl)
        }
    }
    func setupViewControllers(){
        self.delegate = self
        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        //ProfileTap
        let profileNavController = UINavigationController(rootViewController: UserProfileTab(collectionViewLayout: UICollectionViewFlowLayout()))
        profileNavController.tabBarItem.image = profileImageUnSelected.image
        profileNavController.tabBarItem.selectedImage = profileImageSelected.image
        
        //HomeTap
        let layoutx = UICollectionViewFlowLayout()
        let homeNavController = setupNavControllers(selectedImageName: "homeUnselected", UnselectedImageName: "homeSelected", rootCollectionView: HomeViewController(collectionViewLayout: layoutx))
        //SearchTap
        let layoutS = UICollectionViewFlowLayout()
        let searchNavController = setupNavControllers(selectedImageName: "search", UnselectedImageName: "search", rootCollectionView: SearchController(collectionViewLayout: layoutS))
        //LikeTab
        let one = UIViewController()
        one.view.backgroundColor = .white
        one.tabBarItem.image = resizeImage(image: UIImage(imageLiteralResourceName: "likeUnselected"), targetSize: CGSize(width: 40, height: 40)).withRenderingMode(.alwaysOriginal)
        one.tabBarItem.selectedImage = resizeImage(image: UIImage(imageLiteralResourceName: "likeSelected"), targetSize: CGSize(width: 35, height: 35)).withRenderingMode(.alwaysOriginal)
        //AddPlusTap
        let two = UIViewController()
        two.view.backgroundColor = .white
        two.tabBarItem.image = resizeImage(image: UIImage(imageLiteralResourceName: "addUnselected"), targetSize: CGSize(width: 40, height: 40)).withRenderingMode(.alwaysOriginal)
        two.tabBarItem.selectedImage = resizeImage(image: UIImage(imageLiteralResourceName: "addSelected"), targetSize: CGSize(width: 40, height: 40)).withRenderingMode(.alwaysOriginal)
        
        
        
        viewControllers = [homeNavController,searchNavController,two,one,profileNavController]
        
        //modifie items in tab bar
        guard  let items = tabBar.items else {return}
        for items in items {
            items.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func setupNavControllers(selectedImageName : String ,UnselectedImageName : String ,rootCollectionView : UICollectionViewController) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootCollectionView)
        navController.tabBarItem.image = resizeImage(image: UIImage(imageLiteralResourceName: selectedImageName), targetSize: CGSize(width: 45, height: 45)).withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = resizeImage(image: UIImage(imageLiteralResourceName: UnselectedImageName), targetSize: CGSize(width: 40, height: 40)).withRenderingMode(.alwaysOriginal)
        
        return navController
        
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
