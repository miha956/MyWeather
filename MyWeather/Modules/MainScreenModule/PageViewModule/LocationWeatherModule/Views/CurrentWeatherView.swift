//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Миша Вашкевич on 06.04.2024.
//

import Foundation
import UIKit
import SnapKit

final class CurrentWeatherView: UIView {
    
    // MARK: SubViews
    
    private let locationNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    let miniWearherPresenterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        label.alpha = 0
        return label
    }()
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 50, weight: .light)
        label.sizeToFit()
        return label
    }()
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    private let tempMinLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    private let tempMaxLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    private let tempStackview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    private var animatedConstraint: NSLayoutConstraint!
    private let maxConstraintConstant: CGFloat = 25
    
    // MARK: lifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private func setupView() {
        
        addSubViews(locationNameLabel,miniWearherPresenterLabel,temperatureLabel,weatherDescriptionLabel,tempStackview)
        tempStackview.addArrangedSubview(tempMaxLabel)
        tempStackview.addArrangedSubview(tempMinLabel)
        
        
        animatedConstraint = locationNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: maxConstraintConstant)
        animatedConstraint.isActive = true
        locationNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        miniWearherPresenterLabel.snp.makeConstraints { make in
            make.top.equalTo(locationNameLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(locationNameLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        tempStackview.snp.makeConstraints { make in
            make.top.equalTo(weatherDescriptionLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview { $0.snp.bottom }
        }
    }
    
    // MARK: PUblic
    
    func confingView(info: (locationName: String, temperature: String, weatherDescription: String, tempMax: String, tempMin: String)) {
        locationNameLabel.text = info.locationName
        miniWearherPresenterLabel.text = "\(info.temperature) | \(info.weatherDescription)"
        temperatureLabel.text = "\(info.temperature)"
        weatherDescriptionLabel.text = info.weatherDescription
        tempMaxLabel.text = "Макс.:\(info.tempMax),"
        tempMinLabel.text = "Мин.:\(info.tempMin)"
    }
    
    func squeezeView(animationCompletionPercent: CGFloat) {
        tempStackview.alpha = 5 * (0.41 - animationCompletionPercent)
        weatherDescriptionLabel.alpha = 5 * (0.62 - animationCompletionPercent)
        temperatureLabel.alpha = 5 * (0.8 - animationCompletionPercent)
        miniWearherPresenterLabel.alpha = (animationCompletionPercent - 0.89) * 10
        animatedConstraint.constant = maxConstraintConstant - animationCompletionPercent * 30
    }
    
}
