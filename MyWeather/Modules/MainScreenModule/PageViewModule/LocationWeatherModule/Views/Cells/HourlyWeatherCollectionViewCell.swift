//
//  HourlyWeatherCollectionViewCell.swift
//  Weather
//
//  Created by Миша Вашкевич on 06.04.2024.
//

import Foundation
import UIKit
import SnapKit

final class HourlyCollectionViewCell: UICollectionViewCell {
    
    // MARK: Subviews
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let precipitationProbabilityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9)
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    private let imagePrecipitationProbabilityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 1
        return stackView
    }()
    
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
        
        backgroundColor = .clear
        contentView.addSubViews(hourLabel,imagePrecipitationProbabilityStackView,tempLabel)
        imagePrecipitationProbabilityStackView.addArrangedSubview(weatherImageView)
        
        hourLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.leading.equalToSuperview()
        }
        weatherImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        imagePrecipitationProbabilityStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        tempLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: Public
    
    func configView(info : (hour: String, weatherImage: UIImage, temperature: String, precipitationProbability: String?)) {
        hourLabel.text = info.hour
        weatherImageView.image = info.weatherImage
        tempLabel.text = "\(info.temperature)"
        
        if let precipitation = info.precipitationProbability {
            imagePrecipitationProbabilityStackView.addArrangedSubview(precipitationProbabilityLabel)
            self.precipitationProbabilityLabel.text = precipitation
        }
    }
    
}
