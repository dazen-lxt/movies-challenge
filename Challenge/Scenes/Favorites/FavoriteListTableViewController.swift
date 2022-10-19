//
//  FavoriteListTableViewController.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 16/10/22.
//

import UIKit

final class FavoriteListTableViewController: BaseViewController {

    // MARK: - Private properties -
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = Colors.defaultBackground
        return tableView
    }()
    private var viewModel: [FavoriteMovieViewModel] = []

    // MARK: - Internal properties -
    var interactor: FavoriteListBusinessLogic?
    var router: FavoriteListWireframeLogic?

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        configureNavigationBar()
    }

    // MARK: - Private methods -
    private func getData() {
        showLoading()
        interactor?.fetchData()
    }

    private func setupTable() {
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "FavoriteTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }

    private func configureNavigationBar() {
        parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease"),
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
    }

    // MARK: - Actions -
    @objc private func reloadButtonPressed() {
        getData()
    }

    @objc private func filterButtonTapped() {
        router?.showFilters()
    }
}

// MARK: - FavoriteListDisplayLogic -
extension FavoriteListTableViewController: FavoriteListDisplayLogic {
    func displayFavoriteMovies(viewModel: [FavoriteMovieViewModel]) {
        hideLoading()
        self.viewModel = viewModel
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource -
extension FavoriteListTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
}

// MARK: - UITableViewDelegate -
extension FavoriteListTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavoriteTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let item: FavoriteMovieViewModel = viewModel[indexPath.row]
        cell.configureView(item: item)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.selectMovie(viewModel[indexPath.row].id)
        router?.goToDetail()
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil
        ) { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            let favorite = self.viewModel[indexPath.row]
            self.interactor?.deleteFavorite(id: favorite.id)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
