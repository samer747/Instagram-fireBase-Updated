//
//  CommentInputTextView.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 7/10/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit
class CustomTextView: UITextView {
    
     let placeHolder : UILabel = {
       let l = UILabel()
        l.textColor = .lightGray
        return l
    }()
    // ----------- constructor 1 ----------------
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification , object: nil)
        
        addSubview(placeHolder)
        placeHolder.anchor(top: topAnchor, paddingTop: 8, bottom: bottomAnchor, paddingBottom: 0, leading: leadingAnchor, paddingLeft: 8, trailing: trailingAnchor, paddingRight: 0, width: 0, height: 0)
    }
   
    @objc func handleTextChange(){
        
        placeHolder.isHidden = !self.text.isEmpty
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
