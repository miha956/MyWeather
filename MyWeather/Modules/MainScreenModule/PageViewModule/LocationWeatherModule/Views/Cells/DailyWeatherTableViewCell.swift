//
//  DailyWeatherTableViewCell.swift
//  Weather
//
//  Created by Миша Вашкевич on 06.04.2024.
//

import UIKit
import SnapKit

final class DailyWeatherTableViewCell: UITableViewCell {
    
    // MARK: Subviews
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let precipitationProbabilityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9)
        label.textColor = .black
        return label
    }()
    private let imagePrecipitationProbabilityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 1
        return stackView
    }()
    
    private let minTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    private let maxTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    private let tempStackview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: lifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private func setupView() {
        
        backgroundColor = .clear
        
        [minTempLabel, maxTempLabel].forEach {tempStackview.addArrangedSubview($0); $0.snp.makeConstraints {$0.width.equalTo(40)}}
        imagePrecipitationProbabilityStackView.addArrangedSubview(weatherImageView)
        
        contentView.addSubViews(dateLabel,
                                imagePrecipitationProbabilityStackView,
                                tempStackview)
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(80)
        }
        weatherImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        imagePrecipitationProbabilityStackView.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }
        tempStackview.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: Public
    
    func config(info: (date: String, weatherImage: UIImage, precipitationProbability: String?, minTemp: String, maxTemp: String)) {
        self.dateLabel.text = info.date
        self.weatherImageView.image = info.weatherImage
        
        if let precipitation = info.precipitationProbability {
            imagePrecipitationProbabilityStackView.addArrangedSubview(precipitationProbabilityLabel)
            self.precipitationProbabilityLabel.text = precipitation
        }
        self.minTempLabel.text = "\(info.minTemp)"
        self.maxTempLabel.text = "\(info.maxTemp)"
    }
}
