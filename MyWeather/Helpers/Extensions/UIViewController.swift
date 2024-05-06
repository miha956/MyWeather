//
//  UIViewControllerExtention.swift
//  Weather
//
//  Created by Миша Вашкевич on 03.04.2024.
//

import UIKit

extension UIViewController {
    
    func addSubViews(_ views: UIView...) {
        for i in views {
            self.view.addSubview(i)
        }
    }
    
}
