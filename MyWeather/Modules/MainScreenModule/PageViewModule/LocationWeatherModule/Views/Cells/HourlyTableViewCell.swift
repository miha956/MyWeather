//
//  HourlyTableViewCell.swift
//  Weather
//
//  Created by Миша Вашкевич on 06.04.2024.
//

import UIKit

final class HourlyTableViewCell: UITableViewCell {
    
    // MARK: SubViews
    
    private let hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 40, height: 77)
        layout.sectionInset.left = 10
        layout.sectionInset.right = 10
        layout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.registerCell(cellClass: HourlyCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
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
        contentView.addSubview(hourlyCollectionView)
        hourlyCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    // MARK: Public
    
    func collectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate) {
        hourlyCollectionView.delegate = dataSourceDelegate
        hourlyCollectionView.dataSource = dataSourceDelegate
        hourlyCollectionView.reloadData()
    }
}
