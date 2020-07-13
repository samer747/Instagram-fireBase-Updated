//
//  CustomAnimationPresnter.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 7/6/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit

class CustomAnimationDismiss: NSObject , UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return } /// el view ely ray7nlo
        guard let fromView = transitionContext.view(forKey: .from) else { return } /// el view ely e7na gayeen mno
        
        containerView.addSubview(toView)
        
        let startingFrame = CGRect(x: toView.frame.width, y: 0, width: toView.frame.width , height: toView.frame.height)
        toView.frame = startingFrame
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width , height: toView.frame.height)
            fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            
        }) { (_) in
            transitionContext.completeTransition(true) /// el animation 5els
        }
    }
}
