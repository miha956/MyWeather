//
//  UICollectionView.swift
//  Weather
//
//  Created by Миша Вашкевич on 06.04.2024.
//

import UIKit

public extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(cellClass: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.defaultIdentifier)
    }
    
    func dequeue<T: UICollectionViewCell>(cellClass: T.Type, indexPath: IndexPath) -> T {
        return self.dequeue(withIdentifier: cellClass.defaultIdentifier, indexPath: indexPath)
    }

    private func dequeue<T: UICollectionViewCell>(withIdentifier id: String, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! T
    }
}
