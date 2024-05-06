//
//  UIView.swift
//  Weather
//
//  Created by Миша Вашкевич on 05.04.2024.
//

import UIKit

extension UIView {
    
    func addSubViews(_ views: UIView...) {
        for i in views {
            self.addSubview(i)
        }
    }
    
}
