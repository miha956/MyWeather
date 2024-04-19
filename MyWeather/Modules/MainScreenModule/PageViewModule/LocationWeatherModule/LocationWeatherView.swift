//
//  CityWeatherView.swift
//  Weather
//
//  Created by Миша Вашкевич on 06.04.2024.
//

import UIKit
import SnapKit

class LocationWeatherView: UIViewController {
    
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
        indicator.tintColor = .darkGray
        indicator.isHidden = true
        return indicator
    }()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.square.dashed")
        imageView.tintColor = .black
        let tap = UITapGestureRecognizer(target: self, action: #selector(useCurrentLocation))
        tap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = true
        return imageView
    }()
    private lazy var addLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
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
    
    @objc func useCurrentLocation() {
        viewModel.getCurrentLocation(alertPresenter: self)
        setupView()
    }
    
    @objc func addLocationButtonTapped() {
        viewModel.saveNewLocationButtonTapped()
        self.dismiss(animated: true)
    }
    
    // MARK: Private
    
    private func bindViewModel() {
        viewModel.dataFetchState = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .initial:
                print("initial")
            case .loading:
                print("loading")
                imageView.isHidden = true
                activityIndicator.isHidden = false
                weatherTableView.isHidden = true
                currentWeatherView.isHidden = true
                activityIndicator.startAnimating()
            case .success:
                print("success")
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
        case .location, .addLocation:
            
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
        case .requestUseAuthorization:
            addSubViews(imageView)
            imageView.isHidden = false
            imageView.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
                make.height.width.equalTo(100)
            }
        case .authorized:
            viewModel.getCurrentLocation(alertPresenter: self)
            setupView()
        }
    }
}

    // MARK: TableView delegate&dataSourse

extension LocationWeatherView: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cornerRadius : CGFloat = 20.0
        cell.backgroundColor = UIColor.clear
        let layer: CAShapeLayer = CAShapeLayer()
        let pathRef:CGMutablePath = CGMutablePath()
        let bounds: CGRect = cell.bounds.insetBy(dx:0,dy:0)
        var addLine: Bool = false
        
        if (indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
            pathRef.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if (indexPath.row == 0) {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.midY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to:CGPoint(x: bounds.maxX, y: bounds.maxY) )
            addLine = true
        } else if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY), transform: CGAffineTransform())
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to:CGPoint(x: bounds.maxX, y: bounds.minY) )
            
        } else {
            pathRef.addRect(bounds)
            addLine = true
        }
        layer.path = pathRef
        layer.fillColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.8).cgColor
        
        if (addLine == true) {
            let lineLayer: CALayer = CALayer()
            let lineHeight: CGFloat = (1.0 / UIScreen.main.scale)
            lineLayer.frame = CGRect(x:bounds.minX + 10 , y:bounds.size.height-lineHeight, width:bounds.size.width-10, height:lineHeight)
            lineLayer.backgroundColor = tableView.separatorColor?.cgColor
            layer.addSublayer(lineLayer)
        }
        let view: UIView = UIView(frame: bounds)
        view.layer.insertSublayer(layer, at: 0)
        view.backgroundColor = UIColor.clear
        cell.backgroundView = view
    }
}

    // MARK: ScrollView

extension LocationWeatherView {
    
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

extension LocationWeatherView: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
