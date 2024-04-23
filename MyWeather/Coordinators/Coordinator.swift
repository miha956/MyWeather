//
//  CoordinarProtocol.swift
//  Weather
//
//  Created by Миша Вашкевич on 02.04.2024.
//

import UIKit

public protocol Coordinator: AnyObject  {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

public extension Coordinator {
    
    
    func addChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
    
}

