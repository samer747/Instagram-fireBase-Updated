//
//  Utils.swift
//  Instagram fireBase
//
//  Created by samer mohamed on 7/3/20.
//  Copyright © 2020 samer mohamed. All rights reserved.
//

import UIKit

class Utils {

    static func displayAlert(title: String, message: String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert )
        let defaultAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)

        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("keyWindow has no rootViewController")
          
        }

        viewController.present(alertController, animated: true, completion: nil)
    }

}
