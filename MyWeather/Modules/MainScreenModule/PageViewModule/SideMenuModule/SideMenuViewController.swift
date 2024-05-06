//
//  SideMenuViewController.swift
//  MyWeather
//
//  Created by Миша Вашкевич on 02.05.2024.
//

import UIKit
import SnapKit
import CoreData

final class SideMenuViewController: UIViewController {

    // MARK: Properties

    private let viewModel: SideMenuViewModelProtocol
    
    // MARK: SubViews
    private let favoriteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Избранное"
        return label
    }()
    private let settingsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private lazy var placesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.registerCell(cellClass: PlaceTableViewCell.self)
        return tableView
    }()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    init(viewModel: SideMenuViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        viewModel.subscribeFetchResultController(delegate: self)
        
        view.backgroundColor = .appBlack
        
        addSubViews(favoriteLabel,placesTableView)
        
        favoriteLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(250)
        }
        
        placesTableView.snp.makeConstraints { make in
            make.top.equalTo(favoriteLabel.snp.bottom)
            make.trailing.bottom.equalToSuperview().inset(10)
            make.width.equalTo(250)
        }
    }

}
    // MARK: TableView delegate&dataSourse
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfPlaces
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let placeCell = tableView.dequeue(cellClass: PlaceTableViewCell.self)
        placeCell.configView(info: viewModel.getFavoritePlaces(indexPath: indexPath))
        return placeCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "") { [weak self] contextualAction, view, completionHandler in
            self?.viewModel.deletePlace(at: indexPath)
            completionHandler(true)
        }
        deleteButton.backgroundColor = .appBlack
        deleteButton.image = UIImage(named: "delete")
        
        let config = UISwipeActionsConfiguration(actions: [deleteButton])
          config.performsFirstActionWithFullSwipe = false
          return config
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let cornerRadius = 20
        cell.backgroundColor = .appWhite
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

extension SideMenuViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            placesTableView.reloadData()
        case .delete:
            placesTableView.deleteSections([indexPath!.section], with: .automatic)
        case .move:
            placesTableView.reloadData()
        case .update:
            placesTableView.reloadData()
        @unknown default:
            fatalError()
        }
    }
}
