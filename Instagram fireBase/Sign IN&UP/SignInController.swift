//
//  SignInController.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/16/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit
import Firebase
class SignInController: UIViewController {
    
    //MARK: //-------------add statusBar Style ------------
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    //MARK: //-------------add TopContainer ------------
    let IGLable : UILabel = {
        let L = UILabel()
        L.text = "InstaGram"
        L.font = UIFont.italicSystemFont(ofSize: 50)
        L.isHighlighted = true
        L.shadowColor = .black
        L.highlightedTextColor = .white
        L.textAlignment = .center
        L.textColor = .white
        return L
    }()
    let viewx : UIView = {
       let v = UIView()
        v.backgroundColor = .systemBlue
        return v
    }()
    //MARK: //-------------add SignUpButton ------------
    let signUpButton : UIButton = {
        let btn = UIButton(type: .system )
        btn.blindToKeyboard()
        let attText = NSMutableAttributedString(string: "You dont have account ? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.systemGray2])
        attText.append(NSMutableAttributedString(string: "SignUp.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.systemBlue]))
        btn.setAttributedTitle(attText, for: .normal)
        btn.addTarget(self, action: #selector(handleSignUpButton), for: .touchUpInside)
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
    //MARK: //-------------add SignIpButton------------
    let signInBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("SignIn", for: .normal)
        btn.titleLabel?.font=UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleSignInButton), for: .touchUpInside)
        return btn
    }()
    //MARK: //------------- View Did Load ------------
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.view.backgroundColor = .white
           
        }
         setupLayouts()
        navigationController?.isNavigationBarHidden = true
        
    }
    //MARK: //------------- Setup Layouts ------------
    func setupLayouts(){
        view.addSubview(signUpButton)
        view.addSubview(viewx)
        viewx.addSubview(IGLable)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInBtn)
              
        signUpButton.anchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, leading: view.leadingAnchor, paddingLeft: 0, trailing: view.trailingAnchor, paddingRight: 0, width: 0, height: 50)
        viewx.anchor(top: view.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, leading: view.leadingAnchor, paddingLeft: 0, trailing: view.trailingAnchor, paddingRight: 0, width: 0, height: 150)
        emailTextField.anchor(top: viewx.bottomAnchor, paddingTop: 50, bottom: nil, paddingBottom: 0, leading: view.leadingAnchor, paddingLeft: 30 , trailing: view.trailingAnchor, paddingRight: -30, width: 0, height: 50)
        passwordTextField.anchor(top: emailTextField.bottomAnchor, paddingTop: 8, bottom: nil, paddingBottom: 0, leading: view.leadingAnchor, paddingLeft: 30 , trailing: view.trailingAnchor, paddingRight: -30, width: 0, height: 50)
        signInBtn.anchor(top: passwordTextField.bottomAnchor, paddingTop: 8, bottom: nil, paddingBottom: 0, leading: view.leadingAnchor, paddingLeft: 30 , trailing: view.trailingAnchor, paddingRight: -30, width: 0, height: 50)
        IGLable.anchor(top: viewx.topAnchor, paddingTop: 0, bottom: viewx.bottomAnchor, paddingBottom: 0, leading: viewx.leadingAnchor, paddingLeft: 0, trailing: viewx.trailingAnchor, paddingRight: 0, width: 0, height: 0)
        
        
    }
    //MARK: //------------- Handle Functions ------------
    @objc func handleSignUpButton(){
    let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    @objc func handleSignInButton(){
        guard let email = emailTextField.text else {return}
        guard let pass = passwordTextField.text else {return}
        Auth.auth().signIn(withEmail: email, password: pass) { (res, err) in
            if let err = err{
                print("Error : ",err)
                return
            }
            print("Seccsefully Loged In With User : ",res?.user.uid ?? "Empty result")
           self.dismiss(animated: true, completion: nil)
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarViewController else { return }
            mainTabBarController.setupViewControllers()
            
            
        }
    }
    @objc private func handleTextInputChange()
    {
        if passwordTextField.text == "" || emailTextField.text == ""
        {
            signInBtn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        }
        else
        {
            signInBtn.backgroundColor = .systemBlue
            signInBtn.isEnabled = true
        }
    }

    

}
