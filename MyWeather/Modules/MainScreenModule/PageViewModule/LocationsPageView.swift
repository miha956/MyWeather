//
//  LocationsPageController.swift
//  Weather
//
//  Created by Миша Вашкевич on 15.04.2024.
//
//
import Foundation
import UIKit
import SnapKit

final class LocationsPageView: UIViewController {
    
    // MARK: Properties
    
    private var viewModel: LocationsPageViewModelProtocol
    
    // MARK: SubViews
    private lazy var pageViewController: UIPageViewController = {
        let view = UIPageViewController(transitionStyle: .scroll,
                                        navigationOrientation: .horizontal)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private lazy var addLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "location"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .appBlack
        button.addTarget(self, action: #selector(addLOcationButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var cideMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.tintColor = .appBlack
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(showSideMenu), for: .touchUpInside)
        return button
    }()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.backgroundColor = .clear
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .appBlack
        pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
        return pageControl
    }()
    // MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.fetchViews()
        
    }
    
    init(viewModel: LocationsPageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    // MARK: Private
    
    private func bindViewModel() {
        viewModel.dataFetchState = { [weak self] state in
            guard let self = self else {return}
            
            switch state {
            case .initial:
                print("initial")
            case .loading:
                print("loading")
            case .success:
                pageControl.numberOfPages = viewModel.numberOfPages
                guard let firstViewController = viewModel.views.first else { return } // add alert
                pageViewController.setViewControllers([firstViewController],
                                            direction: .forward,
                                            animated: true,
                                            completion: nil)
            case .error(let error):
                showAlert(title: "error", message: error?.localizedDescription, target: self, handler: nil)
            }
            
        }
    }
    
    
    func setupView() {
        
        view.backgroundColor = .appWhite
        addChild(pageViewController)
        addSubViews(pageControl, pageViewController.view,addLocationButton,cideMenuButton)
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(addLocationButton.snp.leading)
            make.leading.equalTo(cideMenuButton.snp.trailing)
            make.height.equalTo(40)
        }
        addLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(pageControl)
            make.height.width.equalTo(30)
        }
        cideMenuButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalTo(pageControl)
            make.height.width.equalTo(30)
        }
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: Actions
    
    @objc private func addLOcationButtonTapped() {
        viewModel.locationsListButtonTapped()
    }
    @objc private func showSideMenu() {
    }
    @objc func pageControlTapped(_ sender: UIPageControl) {
    }
}

    // MARK: PageView Delegate&DataSource

extension LocationsPageView: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
  
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

    }
}
