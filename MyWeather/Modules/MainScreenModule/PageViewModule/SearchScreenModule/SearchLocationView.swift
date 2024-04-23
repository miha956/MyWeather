//
//  SearchScreenModule.swift
//  Weather
//
//  Created by Миша Вашкевич on 13.04.2024.
//

import Foundation
import UIKit

final class SearchLocationView: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: SearchLocationViewModelProtocol
    
    // MARK: SubViews
    
    private let headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Погода"
        label.textColor = .appBlack
        label.font = .systemFont(ofSize: 35)
        return label
    }()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .appBlack
        searchBar.searchTextField.backgroundColor = .appWhite
        searchBar.showsCancelButton = false
        searchBar.tintColor = .appBlack
        searchBar.searchTextField.tintColor = .appBlack
        searchBar.searchTextField.leftView?.tintColor = .appBlack
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Поиск города",
                                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        searchBar.delegate = self
        return searchBar
    }()
    private lazy var locationsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = 1
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.registerCell(cellClass: LocationTableViewCell.self)
        return tableView
    }()
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    init(viewModel: SearchLocationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("SearchLocationView deinit")
    }
    
    // MARK: Private
    
    @objc func handleLocationAdded() {
        viewModel.goToRoot()
    }
    
    // MARK: Private
    
    private func setupView() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocationAdded), name: Notification.Name("LocationAdded"), object: nil)
        view.backgroundColor = .appWhite
        
        addSubViews(headerTitle,searchBar,locationsTableView,errorLabel)
        
        headerTitle.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().inset(20)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(15)
        }
        locationsTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        errorLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

    // MARK: TableView delegate&dataSourse

extension SearchLocationView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchCell = tableView.dequeue(cellClass: LocationTableViewCell.self)
        searchCell.configView(info: viewModel.confinCell(for: indexPath))
        return searchCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.locationSelected(indexPath: indexPath, presenter: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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

// MARK: SearchBar delegate

extension SearchLocationView: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.resignFirstResponder()
        searchBar.searchTextField.text = nil
        viewModel.removeSearchResult()
        locationsTableView.reloadData()	
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchLocation(name: searchText) {
            DispatchQueue.main.async {
                self.locationsTableView.reloadData()
            }
        }
    }
}
