//
//  PhotoSelectorController.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/18/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    
    //MARK: ----------------- ViewDidLoad -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: "photoSelectorCellId")
        collectionView?.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader  , withReuseIdentifier: "photoSelectorHeaderId")
        
        setupNavButtons()
        fetchPhotos()
    }
    //MARK: ----------------- Fetching Photos ---------------------
    
    
    var images = [UIImage]()
    var assests = [PHAsset]()
    var selectedImage : UIImage?
    
    fileprivate func fetchOptions() -> PHFetchOptions
    {
        let fetchOptions = PHFetchOptions() ///constract options
        fetchOptions.fetchLimit = 0 /// limit num of fetched images
        let sortD = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortD]
        return fetchOptions
    }
    
    fileprivate func fetchPhotos(){
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions())///fetch the photos with the options rules
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                let imageManger = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManger.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
                    if let image = image {
                        
                        self.assests.append(asset)
                        self.images.append(image)
                        
                        if self.selectedImage == nil {
                            self.selectedImage = image
                            
                        }
                    }
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    //MARK: ----------------- Header setup ------------------------
    var header : PhotoSelectorHeader?
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "photoSelectorHeaderId", for: indexPath) as! PhotoSelectorHeader
        if let selectedImage = selectedImage{
            self.header = header
            if let index = self.images.firstIndex(of: selectedImage){
                let selectedAssets = assests[index]
                let imageManger = PHImageManager.default()
                imageManger.requestImage(for: selectedAssets, targetSize: CGSize(width: 600, height: 600), contentMode: .default, options: nil) { (image, info) in
                    header.image.image = image
                }
            }
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
    }
    
    //MARK: ----------------- Cells setup -------------------------
   
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = images[indexPath.item]
        self.collectionView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        let size  = CGSize(width: width, height: width)
        return size
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoSelectorCellId", for: indexPath) as! PhotoSelectorCell
        cell.imageI.image = images[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    //MARK: ----------------- Handle status bar -------------------------
    override var prefersStatusBarHidden: Bool{
        return true
    }
    //MARK: ----------------- Handle buttons NavBar-------------------------
    fileprivate func setupNavButtons(){
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNextButton))
    }
    @objc func handleCancelButton(){
        dismiss(animated: true, completion: nil)
    }
    @objc func handleNextButton()
    {
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = self.header?.image.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
}
