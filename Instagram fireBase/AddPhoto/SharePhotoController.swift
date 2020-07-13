//
//  SharePhotoController.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/22/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//
import Firebase
import UIKit

class SharePhotoController: UIViewController {
    
    var selectedImage : UIImage? {
        didSet{
            self.image.image = selectedImage
        }
    }
    
    let containerView : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    let image : UIImageView = {
        let i = UIImageView()
        i.backgroundColor = .red
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        return i
    }()
    let text : CustomTextView = {
        let t = CustomTextView()
        t.font = UIFont.boldSystemFont(ofSize: 14)
        t.placeHolder.text = "Add Caption ..."
        t.placeHolder.font = UIFont.boldSystemFont(ofSize: 14)
        t.textColor = .black
        return t
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 240/255, green: 240/255, blue: 240/255, alpha: 1))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        setupLayouts()
    }
    fileprivate func setupLayouts()
    {
        view.addSubview(containerView)
        containerView.addSubview(image)
        containerView.addSubview(text)
        
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, leading: view.leadingAnchor, paddingLeft: 0, trailing: view.trailingAnchor, paddingRight: 0, width: 0, height: 100 )
        image.anchor(top: containerView.topAnchor, paddingTop: 8, bottom: containerView.bottomAnchor, paddingBottom: -8, leading: containerView.leadingAnchor, paddingLeft: 8, trailing: nil, paddingRight: 0, width: 86, height: 0)
        text.anchor(top: containerView.topAnchor, paddingTop: 8, bottom: containerView.bottomAnchor, paddingBottom: -8, leading: image.trailingAnchor, paddingLeft: 10, trailing: containerView.trailingAnchor, paddingRight: -8, width: 0, height: 0)
    }
    @objc func handleShare()
    {
        guard let image = selectedImage else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        guard let caption = text.text , caption.count > 0 else {
            return
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = false // 34an ndisable el button bta3 el share awl mna5od el data w myfdl4 yrf3 lel data base fahm ?
        
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("postsPhotos").child(fileName)
        
        ref.putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Error PutData : ",err)
                return
            }
            ref.downloadURL { (URL, err) in
                if let err = err {
                    print("DownloadURL Error : ",err)
                    return
                }
                guard let url = URL?.absoluteString else { return }
                self.uploadDownloadURLToDataBase(uRL: url)
            }
        }
    }
    static let notificationShareEndName = NSNotification.Name("notificationShareEndName")
    fileprivate func uploadDownloadURLToDataBase(uRL: String)
    {
        guard let postPhoto = selectedImage else { return }
        guard  let caption = text.text else {return}
        guard let id = Auth.auth().currentUser?.uid else {return}
        let dataBaseRef = Database.database().reference().child("Posts").child(id)
        let ref = dataBaseRef.childByAutoId()
        
        let values = ["ImageUrl": uRL ,"Caption": caption,"PhotoWidth": postPhoto.size.width,"Photoheight": postPhoto.size.height,"CreationDate": Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err{
                print("UpdateChildError : ",err)
                return
            }
            print("Upload URL to DataBase Succesfully")
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: SharePhotoController.notificationShareEndName, object: nil)
        }
        
        
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
