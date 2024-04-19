//
//  LocationTableViewCell.swift
//  Weather
//
//  Created by Миша Вашкевич on 18.04.2024.
//

import Foundation
import UIKit
import SnapKit

final class LocationTableViewCell: UITableViewCell {
    
    // MARK: SubViews
    
    private let locationNameLabel:  UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private let timeLabel:  UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = .appWhite
        return timeLabel
    }()
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    private let tempLabel:  UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = .systemFont(ofSize: 35)
        return label
    }()
    private let tempMinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    private let tempMaxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    private let imagePlusView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.square.dashed")
        imageView.tintColor = .appWhite
        return imageView
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
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        backgroundColor = .appBlack
        
        contentView.addSubViews(locationNameLabel,timeLabel,weatherDescriptionLabel,tempLabel,tempMinLabel,tempMaxLabel)
        
        locationNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(locationNameLabel.snp.bottom)
        }
        tempLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
        }
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        tempMinLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(10)
        }
        tempMaxLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.trailing.equalTo(tempMinLabel.snp.leading)
        }
    }
    
    // MARK: Public
    
    func configView(info: (locationName: String, time: String, temp: String, weatherDescription: String, tempMin: String, tempMax: String)?) {
        
        guard let info = info else {
            contentView.addSubview(imagePlusView)
            imagePlusView.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
                make.height.width.equalTo(50)
            }
            return
        }
        
        self.locationNameLabel.text = info.locationName
        self.timeLabel.text = info.time
        self.tempLabel.text = info.temp
        self.weatherDescriptionLabel.text = info.weatherDescription
        self.tempMinLabel.text = info.tempMin
        self.tempMaxLabel.text = info.tempMax
    }
}
