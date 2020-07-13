//
//  Extentions.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 6/12/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit
import Firebase

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat, bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat, leading: NSLayoutXAxisAnchor?, paddingLeft: CGFloat, trailing: NSLayoutXAxisAnchor?, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: paddingRight).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
extension UIColor {
    static func mainBlue() -> UIColor {
        return UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(r: r, g: g, b: b, a: 1)
    }
}

extension Date {
    func timeAgo() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = minute * 60
        let day = 24 * hour
        let week = 7 * day
        let month = 30 * day
        
        let quotient: Int
        let unit: String
        
        if secondsAgo < 5 {
            quotient = 0
            unit = "Just now"
        } else if secondsAgo < minute {
            quotient = secondsAgo
            if quotient > 1 {
                unit = "seconds"
            } else {
                unit = "second"
            }
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            if quotient > 1 {
                unit = "minutes"
            } else {
                unit = "minute"
            }
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            if quotient > 1 {
                unit = "hours"
            } else {
                unit = "hour"
            }
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            if quotient > 1 {
                unit = "days"
            } else {
                unit = "day"
            }
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            if quotient > 1 {
                unit = "weeks"
            } else {
                unit = "week"
            }
        } else {
            quotient = 0
            let formatter = DateFormatter()
            formatter.dateFormat = "ddmmmmyyyy"
            unit = formatter.string(from: self)
        }
        
        let quotientStr = quotient > 0 ? "\(quotient) " : ""
        let postfix = quotientStr.isEmpty ? "" : " ago"
        let result = quotientStr + unit + postfix
        return result
    }
}

extension UIView{
    func blindToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func keyboardWillChange(_ notification: NSNotification){
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
}
extension UILabel{
    func returnNumOfLines() -> Int {
        let textSize = CGSize(width: self.frame.size.width, height: CGFloat(Float.infinity))
        let rHeight = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(self.font.lineHeight))
        let lineCount = rHeight/charSize
        return lineCount
    }
}
extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}




