//
//  CityWeatherView.swift
//  Weather
//
//  Created by Миша Вашкевич on 06.04.2024.
//

import UIKit
import SnapKit

class LocationWeatherViewController: UIViewController {
    
    // MARK: Properties
    
    private var viewModel: LocationWeatherViewModelProtocol
    private let minConstraintConstant: CGFloat = -70
    private let maxConstraintConstant: CGFloat = 20
    private var animatedConstraint: NSLayoutConstraint!
    private var viewState: LocationWeatherViewState {
        viewModel.viewState
    }
    // MARK: SubViews
    
    private var currentWeatherView: CurrentWeatherView = {
        let view = CurrentWeatherView()
        view.isHidden = true
        return view
    }()
    private lazy var weatherTableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.registerCell(cellClass: HourlyTableViewCell.self)
        tableView.registerCell(cellClass: DailyWeatherTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isHidden = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.tintColor = .appBlack
        indicator.isHidden = true
        return indicator
    }()
    private lazy var addLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.tintColor = .appWhite
        button.backgroundColor = .appBlack
        button.isHidden = true
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addLocationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.fetchWeatherData()
        bindViewModel()
    }
    
    init(viewModel: LocationWeatherViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("LocationWeatherView deinit")
    }
    
    // MARK: Actions
    
    @objc func addLocationButtonTapped() {
        viewModel.saveNewLocationButtonTapped()
        self.dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name("LocationAdded"), object: nil)
    }
    
    // MARK: Private
    
    private func bindViewModel() {
        viewModel.dataFetchState = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .initial:
                print("initial")
            case .loading:
                activityIndicator.isHidden = false
                weatherTableView.isHidden = true
                currentWeatherView.isHidden = true
                activityIndicator.startAnimating()
            case .success:
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
                weatherTableView.reloadData()
                weatherTableView.isHidden = false
                currentWeatherView.isHidden = false
            case .error(let error):
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        
        switch viewState {
        case .location, .addLocation, .currentLocation:
            
            addSubViews(currentWeatherView,weatherTableView,activityIndicator)
            
            currentWeatherView.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(5)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().inset(20)
            }
            
            animatedConstraint = weatherTableView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: maxConstraintConstant)
            animatedConstraint.isActive = true
            weatherTableView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().inset(20)
                make.bottom.equalToSuperview()
            }
            activityIndicator.snp.makeConstraints { make in
                make.centerX.centerY.equalTo(self.view.safeAreaLayoutGuide)
            }
            
            if case .addLocation = viewState {
                addSubViews(addLocationButton)
                addLocationButton.isHidden = false
                addLocationButton.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(20)
                    make.trailing.equalToSuperview().inset(20)
                    make.height.equalTo(40)
                    make.width.equalTo(100)
                }
            }
        }
    }
}

    // MARK: TableView delegate&dataSourse

extension LocationWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        default:
            return 50
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return viewModel.numbersOfDaysCell
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let hourlyWeatherCell = tableView.dequeue(cellClass: HourlyTableViewCell.self)
        let dailyWeatherCell = tableView.dequeue(cellClass: DailyWeatherTableViewCell.self)
        
        switch indexPath.section {
        case 1:
            currentWeatherView.confingView(info: viewModel.getCurrentViewInfo())
            dailyWeatherCell.config(info: viewModel.getDailyWeatherInfo(for: indexPath))
            return dailyWeatherCell
        default:
            hourlyWeatherCell.collectionViewDataSourceDelegate(dataSourceDelegate: self)
            return hourlyWeatherCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //viewModel
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let cornerRadius = 20
        cell.backgroundColor = .appBlack
        var corners: UIRectCorner = []
        if indexPath.row == 0
        {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
        }

        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: cell.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        cell.layer.mask = maskLayer
    }
}

    // MARK: ScrollView

extension LocationWeatherViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
            let currentContentOffsetY = scrollView.contentOffset.y
            let scrollDiff = currentContentOffsetY
            let bounceBorderContentOffsetY = -scrollView.contentInset.top
            let contentMovesUp = scrollDiff > 0 && currentContentOffsetY > bounceBorderContentOffsetY
            let contentMovesDown = scrollDiff < 0 && currentContentOffsetY < bounceBorderContentOffsetY
            let currentConstraintConstant = animatedConstraint.constant
            var newConstraintConstant = currentConstraintConstant
            if contentMovesUp {
                newConstraintConstant = max(currentConstraintConstant - scrollDiff, minConstraintConstant)
            } else if contentMovesDown {
                newConstraintConstant = min(currentConstraintConstant - scrollDiff, maxConstraintConstant)
            }
            if newConstraintConstant != currentConstraintConstant {
                animatedConstraint?.constant = newConstraintConstant
                scrollView.contentOffset.y = 0
            }
        let animationCompletionPercent = (currentConstraintConstant - maxConstraintConstant) / (minConstraintConstant - maxConstraintConstant)
        currentWeatherView.squeezeView(animationCompletionPercent: animationCompletionPercent)
    }
}

    // MARK: CollectionView delegate&dataSourse

extension LocationWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numbersOfHoursCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionHourlyCell = collectionView.dequeue(cellClass: HourlyCollectionViewCell.self, indexPath: indexPath)
        collectionHourlyCell.configView(info: viewModel.getHourlyWeatherInfo(for: indexPath))
        return collectionHourlyCell
    }
    
}
