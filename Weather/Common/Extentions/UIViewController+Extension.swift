//
//  UIViewController+Extension.swift
//  Weather
//
//  Created by Afzaal Ahmad on 09/10/24.
//

import UIKit

extension UIViewController {
    func presentAlert(withTitle title: String, message : String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: title, style: .default, handler: handler)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
