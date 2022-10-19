//
//  ListTableViewController.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 16/10/22.
//

import UIKit

final class ListTableViewController: BaseViewController {

    private let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Colors.defaultBackground
        return collectionView
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
    private var numberOfColumns: CGFloat = 2
    private var viewModel: [MovieViewModel] = []

    var interactor: ListBusinessLogic?
    var router: ListWireframeLogic?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupEmptyView()
        getData()
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }

    private func getData() {
        showLoading()
        interactor?.fetchData()
    }

    private func setupCollection() {
        collectionView.register(
            ItemCollectionViewCell.self,
            forCellWithReuseIdentifier: "ItemCollectionViewCell"
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionView.isHidden = true
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

    private func layoutTrait(traitCollection: UITraitCollection) {
//        if (!sharedConstraints[0].isActive) {
//           // activating shared constraints
//           NSLayoutConstraint.activate(sharedConstraints)
//        }
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            numberOfColumns = 2
//            if regularConstraints.count > 0 && regularConstraints[0].isActive {
//                NSLayoutConstraint.deactivate(regularConstraints)
//            }
//            // activating compact constraints
//            NSLayoutConstraint.activate(compactConstraints)
        } else {
            numberOfColumns = 6
//            if compactConstraints.count > 0 && compactConstraints[0].isActive {
//                NSLayoutConstraint.deactivate(compactConstraints)
//            }
//            // activating regular constraints
//            NSLayoutConstraint.activate(regularConstraints)
        }
        collectionView.reloadData()
    }

    @objc private func reloadButtonPressed() {
        getData()
    }
}

// MARK: - ListDisplayLogic -
extension ListTableViewController: ListDisplayLogic {
    func displayMovies(viewModel: [MovieViewModel]) {
        hideLoading()
        emptyView.isHidden = true
        collectionView.isHidden = false
        self.viewModel = viewModel
        collectionView.reloadData()
    }

    func displayError() {
        hideLoading()
        emptyView.isHidden = false
        collectionView.isHidden = true
    }
}

// MARK: - UICollectionViewDataSource -
extension ListTableViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
}

// MARK: - Delegate -
extension ListTableViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: ItemCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let item: MovieViewModel = viewModel[indexPath.row]
        cell.configureView(item: item)
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor?.selectMovie(viewModel[indexPath.row].id)
        router?.goToDetail()
    }
}
