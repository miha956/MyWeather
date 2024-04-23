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
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
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

        backgroundColor = .clear
        
        contentView.addSubViews(title ,descriptionLabel)
        
        title.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
            make.leading.equalToSuperview().offset(10)
        }

    }
    
    // MARK: Public
    
    func configView(info: (title: String?, description: String?)) {
        self.title.text = info.title
        self.descriptionLabel.text = info.description
    }
}
