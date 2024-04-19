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
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.backgroundColor = .white
        searchBar.showsCancelButton = false
        searchBar.tintColor = .black
        searchBar.searchTextField.tintColor = .black
        searchBar.searchTextField.leftView?.tintColor = .black
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
    
    private func setupView() {
        
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
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locationCell = tableView.dequeue(cellClass: LocationTableViewCell.self)
        
        return locationCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}

// MARK: SearchBar delegate

extension SearchLocationView: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.locationsTableView.alpha = 0.5
        }
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.resignFirstResponder()
        searchBar.searchTextField.text = nil
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
}
