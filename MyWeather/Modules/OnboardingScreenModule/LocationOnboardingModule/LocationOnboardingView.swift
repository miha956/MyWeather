//
//  LocationOnboardingView.swift
//  Weather
//
//  Created by Миша Вашкевич on 02.04.2024.
//

import Foundation
import UIKit
import SnapKit
import CoreLocation

final class LocationOnboardingView: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: LocationOnboardingViewModelProtocol
    
    // MARK: SubViews
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let warningTitleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 16, weight: .bold)
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.textColor = .appBlack
        return view
    }()
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 14, weight: .light)
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.textColor = .appBlack
        return view
    }()
    private lazy var confirmUsingLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appBlack
        button.tintColor = .appWhite
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(requestLocationPermissionButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var skipLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .appBlack
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    init(viewModel: LocationOnboardingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("deinit LocationOnboardingView")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    
    @objc func skipButtonTapped() {
        viewModel.goToSettings()
    }
    
    @objc func requestLocationPermissionButtonTapped() {
        viewModel.requestLocationPermission(locationManagerDelegate: self)
        
    }
    
    // MARK: Private
    
    private func setupView() {
        
        view.backgroundColor = .appWhite
        
        imageView.image = UIImage(named: viewModel.viewData.viewImageName)
        warningTitleLabel.text = viewModel.viewData.title
        descriptionLabel.text = viewModel.viewData.description
        confirmUsingLocationButton.setTitle(viewModel.viewData.buttonTitle, for: .normal)
        skipLocationButton.setTitle(viewModel.viewData.skipButtonTitle, for: .normal)
        
        addSubViews(imageView,
                    warningTitleLabel,
                    descriptionLabel,
                    confirmUsingLocationButton,
                    skipLocationButton)
        
        imageView.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(100)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(200)
        })
        warningTitleLabel.snp.makeConstraints({
            $0.centerY.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
        })
        descriptionLabel.snp.makeConstraints({
            $0.top.equalTo(warningTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
        })
        confirmUsingLocationButton.snp.makeConstraints({
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.height.equalTo(40)
        })
        skipLocationButton.snp.makeConstraints({
            $0.top.equalTo(confirmUsingLocationButton.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-25)
            $0.height.equalTo(40)
        })
        
    }
}

extension LocationOnboardingView: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedWhenInUse:
                print("Разрешение на использование геолокации получено")
                viewModel.goToSettings()
            case .denied:
                print("Пользователь отклонил запрос на использование геолокации")
                viewModel.goToSettings()
            case .notDetermined:
                print("Пользователь еще не принял решение по запросу использования геолокации")
            case .restricted:
                print("Пользователь не может изменить разрешения на использование геолокации")
            case .authorizedAlways:
                print("Пользователь предоставил приложению постоянный доступ к геолокации")
                viewModel.goToSettings()
            @unknown default:
                print("Неизвестный статус разрешения на использование геолокации")
            }
        }
}
