//
//  LocationOnboardingModel.swift
//  Weather
//
//  Created by Миша Вашкевич on 02.04.2024.
//

import UIKit
import CoreLocation


protocol LocationOnboardingViewModelProtocol {
    
    var viewData: LocationOnboardingModel {get}
    func goToSettings()
    func requestLocationPermission(locationManagerDelegate: UIViewController)
}

final class LocationOnboardingViewModel: LocationOnboardingViewModelProtocol {
    
    
    let viewData: LocationOnboardingModel = LocationOnboardingModel()
    var coordinator: OnboardingCoordinator?
    
    private let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    
    deinit {
        print("deinit LocationOnboardingViewModel")
    }
    
    
    func goToSettings() {
        coordinator?.showSettingsView()
    }
    
    func requestLocationPermission(locationManagerDelegate: UIViewController) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = locationManagerDelegate as? any CLLocationManagerDelegate
    }
}
