//
//  SettingsOnboardiingView.swift
//  Weather
//
//  Created by Миша Вашкевич on 04.04.2024.
//

import UIKit
import SnapKit

class SettingsOnboardiingView: UIViewController {

    // MARK: Properties
    
    private let viewModel: SettingsOnboardingViewModelProtocol
    
    // MARK: Subviews
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    private lazy var applySettingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(saveSettingsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureContentStackView()
    }
    
    init(viewModel: SettingsOnboardingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("deinit SettingsOnboardiingView")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc func saveSettingsButtonTapped() {
        viewModel.saveSettings()
    }
    
    @objc func segmentValueChanged(_ sender: UISegmentedControl) {
        viewModel.segmentValueChanged(tag: sender.tag, value: sender.selectedSegmentIndex)
    }
    // MARK: Private
    
    private func setupView() {
        viewModel.loadSettints()
        view.backgroundColor = .white
        
        applySettingsButton.setTitle(viewModel.buttonTitle, for: .normal)
        titleLabel.text = viewModel.viewTitle
        view.addSubview(contentView)
        contentView.addSubViews(titleLabel,
                                contentStackView,
                                applySettingsButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(30)
        }
        
        contentView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(applySettingsButton.snp.bottom).offset(15)
        }
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(30)
            
        }
        applySettingsButton.snp.makeConstraints { make in
            make.top.equalTo(contentStackView.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
        
    }
    
    private func configureContentStackView() {
        for (index, title) in viewModel.viewContent.settingsTitle.enumerated() {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 5
            
            let titleLabel = UILabel()
            titleLabel.text = title.rawValue
            titleLabel.font = .systemFont(ofSize: 16)
            stackView.addArrangedSubview(titleLabel)
            
            let segmentedControl = UISegmentedControl()
            segmentedControl.tintColor = .black
            segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            segmentedControl.selectedSegmentTintColor = .systemBlue
            segmentedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
            
            let options = viewModel.viewContent.optionsTitles[index]
            for (optionIndex, option) in options.options.enumerated() {
                segmentedControl.insertSegment(withTitle: "\(option)", at: optionIndex, animated: false)
            }
            segmentedControl.tag = index
            segmentedControl.selectedSegmentIndex = viewModel.currentSettings[index]
            segmentedControl.snp.makeConstraints { $0.width.equalTo(80) }
            stackView.addArrangedSubview(segmentedControl)
            contentStackView.addArrangedSubview(stackView)
        }
    }
}
