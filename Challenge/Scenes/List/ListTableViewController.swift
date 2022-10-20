//
//  ListTableViewController.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 16/10/22.
//

import UIKit

final class ListTableViewController: BaseViewController {

    // MARK: - Private properties -
    private let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Colors.defaultBackground
        collectionView.accessibilityIdentifier = Identifiers.moviesCollection
        return collectionView
    }()
    private let searchView: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.placeholder = "Search Movies ..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.tintColor = Colors.tintColor
        searchBar.barTintColor = Colors.inverseTintColor
        searchBar.sizeToFit()
        return searchBar
    }()
    private let emptyView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = Colors.defaultBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let reloadButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Reload", for: .normal)
        button.titleLabel?.font = Fonts.subtitle
        button.backgroundColor = Colors.tintColor
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let upScrollButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.backgroundColor = Colors.tintColor
        button.tintColor = Colors.inverseTintColor
        button.layer.cornerRadius = 20.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        button.layer.shadowRadius = 5.0
        button.layer.shadowOpacity = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let emptyMessage: UILabel = {
        let label: UILabel = UILabel()
        label.text = "There was a problem loading the info. Check the connection and try again"
        label.textColor = Colors.defaultTextColor
        label.font = Fonts.title
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var currentCount: Int {
        viewModeList.count
    }
    private var viewModeList: [MovieViewModel] {
        return viewModel?.list ?? []
    }
    private var searchTask: Task<(), Error>?
    private var numberOfColumns: CGFloat = 2
    private var nextPage: Int = 1
    private var viewModel: ListViewModel?
    private let headerIdentifier: String = "headerCellId"
    private var searchTerm: String = ""

    // MARK: - Internal properties -
    var interactor: ListBusinessLogic?
    var router: ListWireframeLogic?

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupEmptyView()
        showLoading()
        getData()
        setupSearchView()
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.refreshFavorites()
        configureNavigationBar()
    }

    // MARK: - Internal methods -
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }

    // MARK: - Private properties -
    private func getData() {
        interactor?.fetchData(page: nextPage)
    }

    private func getDataBySearch(search: String) {
        showLoading()
        nextPage = 1
        viewModel = nil
        if search.isEmpty {
            getData()
        } else {
            interactor?.searchByTerm(page: nextPage, query: search)
        }
    }

    private func configureNavigationBar() {
        parent?.navigationItem.rightBarButtonItem = nil
    }

    private func setupCollection() {
        collectionView.register(
            ItemCollectionViewCell.self,
            forCellWithReuseIdentifier: "ItemCollectionViewCell"
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        view.addSubview(collectionView)
        view.addSubview(upScrollButton)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            upScrollButton.heightAnchor.constraint(equalToConstant: 40.0),
            upScrollButton.widthAnchor.constraint(equalToConstant: 40.0),
            upScrollButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            upScrollButton.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -10)
        ])
        collectionView.isHidden = true
        upScrollButton.addTarget(self, action: #selector(upScrollButtonPressed), for: .touchUpInside)
    }

    private func setupEmptyView() {
        view.backgroundColor = Colors.defaultBackground
        view.addSubview(emptyView)
        emptyView.addSubview(reloadButton)
        emptyView.addSubview(emptyMessage)
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            reloadButton.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor, constant: 0),
            reloadButton.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: 0),
            reloadButton.widthAnchor.constraint(equalToConstant: 200.0),
            reloadButton.heightAnchor.constraint(equalToConstant: 40),
            emptyMessage.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -40.0),
            emptyMessage.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 40.0),
            emptyMessage.bottomAnchor.constraint(equalTo: reloadButton.topAnchor, constant: -40.0)
        ])
        reloadButton.addTarget(self, action: #selector(reloadButtonPressed), for: .touchUpInside)
        emptyView.isHidden = true
    }

    private func setupSearchView() {
        collectionView.register(
            UICollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerIdentifier
        )
    }

    private func layoutTrait(traitCollection: UITraitCollection) {
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            numberOfColumns = 2
        } else {
            numberOfColumns = 5
        }
        collectionView.reloadData()
    }

    // MARK: - Actions -
    @objc private func reloadButtonPressed() {
        showLoading()
        getData()
    }

    @objc private func upScrollButtonPressed() {
        collectionView.setContentOffset(.zero, animated: true)
    }
}

// MARK: - ListDisplayLogic -
extension ListTableViewController: ListDisplayLogic {

    func displayMovies(viewModel: ListViewModel) {
        nextPage += 1
        emptyView.isHidden = true
        collectionView.isHidden = false
        if self.viewModel == nil {
            self.viewModel = viewModel
        } else {
            self.viewModel?.list.append(contentsOf: viewModel.list)
        }
        collectionView.reloadData()
        hideLoading()
    }

    func displayError() {
        hideLoading()
        emptyView.isHidden = false
        collectionView.isHidden = true
    }

    func updateFavorite(isFavorite: Bool, index: Int) {
        self.viewModel?.list[index].isFavorite = isFavorite
        self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
}

// MARK: - UICollectionViewDataSource -
extension ListTableViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.totalResults ?? 0
    }
}

// MARK: - UICollectionViewDelegateFlowLayout -
extension ListTableViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: ItemCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        if isLoadingCell(for: indexPath) {
            cell.configureViewEmpty()
        } else {
            cell.configureView(item: viewModeList[indexPath.row])
        }
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let flowayout: UICollectionViewFlowLayout? = collectionViewLayout as? UICollectionViewFlowLayout
        var space: CGFloat = (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        space += (flowayout?.minimumInteritemSpacing ?? 0.0) * (numberOfColumns - 1)
        let width: CGFloat = floor((collectionView.frame.size.width - space) / numberOfColumns)
        let height: CGFloat = width * 1.5 + 40
        return CGSize(width: width, height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor?.selectMovie(viewModel?.list[indexPath.row].id ?? 0)
        router?.goToDetail()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headerIdentifier,
            for: indexPath
        )
        header.addSubview(searchView)
        searchView.delegate = self
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 0),
            searchView.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: 0),
            searchView.topAnchor.constraint(equalTo: header.topAnchor, constant: 0),
            searchView.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: 0)
        ])
        return header
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if let firstCellRowIndex = collectionView.indexPathsForVisibleItems.first?.row {
            upScrollButton.isHidden = firstCellRowIndex < Int(numberOfColumns)
        }
    }
}

// MARK: - UISearchBarDelegate -
extension ListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        searchTask = Task {
            try await Task.sleep(nanoseconds: 500_000_000)
            DispatchQueue.main.async { [weak self] in
                self?.getDataBySearch(search: searchText)
            }
        }
    }
}

// MARK: - UICollectionViewDataSourcePrefetching -
extension ListTableViewController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            getData()
        }
    }

    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= currentCount
    }

    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
