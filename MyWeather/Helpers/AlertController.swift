//
//  AlertController.swift
//  MyWeather
//
//  Created by Миша Вашкевич on 19.04.2024.
//

import Foundation
import UIKit

public func showAlert(title: String?, message: String?, target: UIViewController, handler: ((UIAlertAction) -> Void)?) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let oklAction = UIAlertAction(title: "ok", style: .cancel)
    alertController.addAction(oklAction)
    target.present(alertController, animated: true)
}
