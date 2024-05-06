//
//  UITableView.swift
//  Weather
//
//  Created by Миша Вашкевич on 04.04.2024.
//

import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(cellClass: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.defaultIdentifier)
    }
    
    func dequeue<T: UITableViewCell>(cellClass: T.Type) -> T {
        return self.dequeue(withIdentifier: cellClass.defaultIdentifier)
    }

    private func dequeue<T: UITableViewCell>(withIdentifier id: String) -> T {
        return self.dequeueReusableCell(withIdentifier: id) as! T
    }
}
