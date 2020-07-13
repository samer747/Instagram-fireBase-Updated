//
//  CameraController.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 7/5/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController , AVCapturePhotoCaptureDelegate , UIViewControllerTransitioningDelegate {
    //MARK: ----------  ----------------
    let takePhotoButton : UIButton = {
       let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "add_image_button"), for: .normal)
        b.backgroundColor = .white
        b.layer.masksToBounds = true
        b.layer.cornerRadius = 25
        b.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        return b
    }()
    //MARK: ---------- backButton ----------------
    let back : UIButton = {
       let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "homeUnselected"), for: .normal)
        b.backgroundColor = .red
        b.layer.masksToBounds = true
        b.layer.cornerRadius = 15
        b.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return b
    }()
    @objc func dismissView(){
        self.dismiss(animated: true) {
            self.captureSession.stopRunning()
        }
    }
    //MARK: ---------- ViewDidLoad ----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        
        
        view.backgroundColor = .black
        setupLayout()
        setupCameraSession()
        
    }
    //MARK: ---------- Animation methods ----------------
    let customAnimationPresnter = CustomAnimationPresnter()
    let customAnimationDismiss = CustomAnimationDismiss()
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresnter
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismiss
    }
    //MARK: ---------- SetupLayOuts ----------------
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    fileprivate func setupLayout(){
        view.addSubview(takePhotoButton)
        view.addSubview(back)
        
        
        takePhotoButton.anchor(top: view.bottomAnchor, paddingTop: -60, bottom: nil, paddingBottom: 0, leading: nil, paddingLeft: 0, trailing: nil, paddingRight: 0, width: 50, height: 50)
        takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        back.anchor(top: view.topAnchor, paddingTop: 15, bottom: nil, paddingBottom: 0, leading: nil, paddingLeft: 0, trailing: view.trailingAnchor, paddingRight: -15, width: 30, height: 30)
        
    }
    //MARK: ---------- CameraSession ----------------
    @objc func takePhoto(){
        print("taking photos")
        //let settings = AVCapturePhotoSettings()
        //output.capturePhoto(with: settings, delegate: self)
        //h2of hna msh ha3rf akml 34ann msh m3aya  iphone agrb 3lih w el xcode msh 3arf ygrbo
    }
    let captureSession = AVCaptureSession()
    let output = AVCapturePhotoOutput() // hna 34an n3rf nenadeha fe el takePhoto()
    fileprivate func setupCameraSession()
    {
        //Camera request
           AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
               if response { /// the user accepted the request
                 //MARK: ------ Setup INput -----------
                guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {return}
                   do {
                   let input = try AVCaptureDeviceInput(device: captureDevice)
                       if self.captureSession.canAddInput(input){
                           self.captureSession.addInput(input)
                           print("x")
                       }
                   } catch let err {
                       print("Couldnt setup camera input", err)
                   }
                //MARK: ------ Setup OutPuts -----------
                if self.captureSession.canAddOutput(self.output){
                    self.captureSession.addOutput(self.output)
                }
                //MARK: ------ Setup output preview -----------
                let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                previewLayer.frame = self.view.frame
                self.view.layer.addSublayer(previewLayer)
                self.captureSession.startRunning()
               }
               else {/// the user dismessed the request
                self.dismiss(animated: true, completion: nil)
               }
           }
    }
   
    
    
}
