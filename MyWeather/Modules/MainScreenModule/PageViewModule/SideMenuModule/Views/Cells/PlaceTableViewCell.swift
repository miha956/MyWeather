//
//  LocationTableViewCell.swift
//  Weather
//
//  Created by Миша Вашкевич on 18.04.2024.
//

import Foundation
import UIKit
import SnapKit

final class PlaceTableViewCell: UITableViewCell {
    
    // MARK: SubViews
    
    private let locationNameLabel:  UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .systemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let tempLabel:  UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    private let tempMinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    private let tempMaxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .systemFont(ofSize: 15)
        return label
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
        
        contentView.addSubViews(locationNameLabel,weatherDescriptionLabel,tempLabel,tempMinLabel,tempMaxLabel)
        
        locationNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
        }

        tempLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
        }
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(150)
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
    
    func configView(info: (locationName: String, temp: String, weatherDescription: String, tempMin: String, tempMax: String)?) {
        
        guard let info = info else {
            return
        }
        
        self.locationNameLabel.text = info.locationName
        self.tempLabel.text = info.temp
        self.weatherDescriptionLabel.text = info.weatherDescription
        self.tempMinLabel.text = "-- \(info.tempMin)"
        self.tempMaxLabel.text = info.tempMax
    }
}
