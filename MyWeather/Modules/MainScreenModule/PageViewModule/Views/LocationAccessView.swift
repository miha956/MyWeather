//
//  LocationAccessView.swift
//  MyWeather
//
//  Created by Миша Вашкевич on 22.04.2024.
//

import Foundation
import UIKit
import SnapKit

final class LocationAccessView: UIViewController {
    
    // MARK: Properties
    
    private var viewModel: LocationsPageViewModelProtocol
    
    // MARK: SubViews
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.square.dashed")
        imageView.tintColor = .appBlack
        let tap = UITapGestureRecognizer(target: self, action: #selector(letUseLocation))
        tap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    init(viewModel: LocationsPageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    
    @objc func letUseLocation() {
        viewModel.requestUseGeolocation(alertPresenter: self)
    }
    
    // MARK: Private
    
    func setupView() {
        
        view.backgroundColor = .clear
        addSubViews(imageView)
        
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
    }
}
