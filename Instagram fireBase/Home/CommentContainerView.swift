//
//  CommentContainerView.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 7/10/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit

protocol CommentDelegate {
    func commentDidPressed(for comment: String)
}

class CommentContainerView: UIView {
    var delegate : CommentDelegate?
    
    fileprivate let commentTextField : CustomTextView = {
        let textField = CustomTextView()
        //textField.placeholder = "Add a comment..."
        textField.isScrollEnabled = false
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.placeHolder.text = "Add Comment ..."
        textField.placeHolder.font = UIFont.systemFont(ofSize: 18)
        return textField
    }()
    fileprivate let sendButton : UIButton = {
        let sendButton = UIButton()
        sendButton.setTitleColor(.systemBlue, for: .normal)
        sendButton.setTitle("Post", for: .normal)
        sendButton.addTarget(self, action: #selector(handlePostingComment), for: .touchUpInside)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return sendButton
    }()
    fileprivate let seprateView : UIView = {
        let seprateViewx = UIView()
    seprateViewx.backgroundColor = .init(r: 230, g: 230, b: 230)
        return seprateViewx
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        addSubview(commentTextField)
        addSubview(sendButton)
        addSubview(seprateView)
        
       
        
        sendButton.anchor(top: topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, leading: nil, paddingLeft: 0, trailing: trailingAnchor, paddingRight: -10, width: 50, height: 50)
        commentTextField.anchor(top: topAnchor, paddingTop: 8, bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: -8, leading: leadingAnchor, paddingLeft: 12, trailing: sendButton.leadingAnchor, paddingRight: 0, width: 0, height: 0)
         seprateView.anchor(top: nil, paddingTop: 0, bottom: topAnchor, paddingBottom: 0, leading: leadingAnchor, paddingLeft: 0, trailing: trailingAnchor, paddingRight: 0, width: 0, height: 1)
        
    }
    //Func bt5ly el height bassed on content size
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    //MARK:----------- Post Button Handle -------------
    @objc fileprivate func handlePostingComment(){
        guard let text = commentTextField.text else { return }
        delegate?.commentDidPressed(for: text)
        commentTextField.text = ""

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
