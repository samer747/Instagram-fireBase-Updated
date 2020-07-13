//
//  ViewController.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/12/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController  , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    //MARK: //-------------add SignInButton------------
    let signInButton : UIButton = {
        let btn = UIButton(type: .system )
        let attText = NSMutableAttributedString(string: "You already have account ? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.systemGray2])
        attText.append(NSMutableAttributedString(string: "LogIn.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.systemBlue]))
        btn.setAttributedTitle(attText, for: .normal)
        btn.addTarget(self, action: #selector(handleSignInButton), for: .touchUpInside)
        return btn
    }()
    
    //MARK: //-------------add +photoButton------------
    let plusPhotoButton : UIButton = {
        let btn = UIButton(type: .system )
        btn.setImage(#imageLiteral(resourceName: "add_image_button").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.addTarget(self, action: #selector(handlePlusPhotoButton), for: .touchUpInside)
        return btn
        
    }()
    
    //MARK: //-------------add emailTextField------------
    let emailTextField : UITextField = {
        let txtF = UITextField()
        txtF.placeholder = "Email"
        txtF.backgroundColor = UIColor(white: 0, alpha: 0.03)
        txtF.borderStyle = .roundedRect
        txtF.font = UIFont.systemFont(ofSize: 14)
        txtF.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return txtF
    }()
    //MARK: -------------add usernameTextField------------
    let usernameTextField : UITextField = {
        let txtF = UITextField()
        txtF.placeholder = "Username"
        txtF.backgroundColor = UIColor(white: 0, alpha: 0.03)
        txtF.borderStyle = .roundedRect
        txtF.font = UIFont.systemFont(ofSize: 14)
        txtF.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return txtF
    }()
    //MARK: //-------------add PasswordTextField------------
    let passwordTextField : UITextField = {
        let txtF = UITextField()
        txtF.placeholder = "Password"
        txtF.isSecureTextEntry = true
        txtF.backgroundColor = UIColor(white: 0, alpha: 0.03)
        txtF.borderStyle = .roundedRect
        txtF.font = UIFont.systemFont(ofSize: 14)
        txtF.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return txtF
    }()
    //MARK: //-------------add SignUpButton------------
    let signUPBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("SignUp", for: .normal)
        btn.titleLabel?.font=UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.mainBlue()
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleSignUpButton), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    //MARK: // -------------didLoad------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupLayouts()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setupLayouts(){
        //MARK: // -------------setup SignIn Button------------
        view.addSubview(signInButton)
        signInButton.anchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, leading: view.leadingAnchor, paddingLeft: 0, trailing: view.trailingAnchor, paddingRight: 0, width: 0, height: 50)
        //MARK: // -------------setup +photoButton------------
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        plusPhotoButton.anchor(top: view.topAnchor, paddingTop: 40, bottom: nil, paddingBottom: 0, leading: nil, paddingLeft: 0, trailing: nil, paddingRight: 0, width: 140, height: 140)
        //MARK: //-------------setup stack of text fields and sign up button------------
        //-------------add stack view for text fields and signUP Button------------
        let stack : UIStackView = {
            let stak = UIStackView(arrangedSubviews: [emailTextField,usernameTextField,passwordTextField,signUPBtn])
            stak.axis = .vertical
            stak.distribution = .fillEqually
            stak.spacing = 10
            return stak
        }()
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, leading: view.leadingAnchor, paddingLeft: 40, trailing: view.trailingAnchor, paddingRight: -40, width: 0, height: 200)
        
    }
    //MARK: //------------------ObjC Func SignIn Button--------------------
    @objc func handleSignInButton()
    {
        navigationController?.popViewController(animated: true)
        
    }
    //MARK: //------------------ObjC Func SignUP photo--------------------
    @objc private func handlePlusPhotoButton()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            plusPhotoButton.setImage(selectedImage!.withRenderingMode(.alwaysOriginal), for: .normal)
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            plusPhotoButton.setImage(selectedImage!.withRenderingMode(.alwaysOriginal), for: .normal)
            picker.dismiss(animated: true, completion: nil)
        }
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.borderWidth = 3
        
        //MARK: //------------------ObjC Func SignUP button--------------------
    }
    @objc private func handleSignUpButton()
    {
        guard let email = emailTextField.text else {return}
        guard let userX = usernameTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let eror = err {
                ///something bad happning
                print("cant signUp : ",eror.localizedDescription)
                return
            }
            ///user registered successfully
            print("signUP succesfully with ID : ",res?.user.uid ?? "mfe4 id")
            guard let userID = res?.user.uid else { return }
            guard let image = self.plusPhotoButton.imageView?.image else {return}        //hna5od el sora mn el imageview nfsaha
            let imageName = NSUUID().uuidString                                               // hn3ml random id lel user
            let ref = Storage.storage().reference().child("profile_images").child(imageName)  // da el refrance ely htet7at feh el sora
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else {return} // da bnghz el sora 34an tetrf3
            ref.putData(uploadData, metadata: nil) { (metadate, err) in                  //method el raf3
                if let error = err { //error
                    print("faild1",error)
                    return
                }
                print(metadate ?? "Succses")//succses
                ref.downloadURL { (url, err) in//method btrg3lna el download url
                    if let err = err//error
                    {   print(err)
                        return
                        
                    }
                    guard let url = url else {return}
                    let dataBaseRef = Database.database().reference() // da el path ref lel data base
                    let user = dataBaseRef.child("Users").child(userID) // bn3ml child fe el ref
                    let dataArray:[String: Any] = ["UserName": userX , "imageURL" : url.absoluteString] // bn7ot kol 7aga fe Dictionary 34an ytrf3o m3 b3d ka 7aga wa7da lel  User
                    user.updateChildValues(dataArray)                 // etrfa3 5lassssss
                    self.dismiss(animated: true, completion: nil)
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarViewController else { return }
                    mainTabBarController.setupViewControllers()
                }
            }
        }
    }
    //MARK: //--------------changing button color depending on text fields---------------
    @objc private func handleTextInputChange()
    {
        if usernameTextField.text == "" || passwordTextField.text == "" || emailTextField.text == ""
        {
            signUPBtn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        }
        else
        {
            signUPBtn.backgroundColor = .systemBlue
            signUPBtn.isEnabled = true
        }
    }
    
    
    
    
    
}

