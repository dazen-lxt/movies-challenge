//
//  MovieDetailViewController.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import AlamofireImage
import UIKit

final class MovieDetailViewController: BaseViewController {

    // MARK: - Private properties -
    private let movieTitle: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = Colors.defaultTextColor
        label.font = Fonts.subtitle
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let movieYear: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = Colors.defaultTextColor
        label.font = Fonts.subtitle
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let favoriteImage: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = Colors.tintColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = Identifiers.detailFavoriteButton
        return button
    }()
    private let movieImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let movieGender: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = Colors.defaultTextColor
        label.font = Fonts.subtitle
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let titleContainer: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let movieBody: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = Colors.defaultTextColor
        label.font = Fonts.paragraph
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var isFavorite: Bool = true {
        didSet {
            let imageName: String = isFavorite ? "heart.fill" : "heart"
            favoriteImage.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    private let margin: CGFloat = 10.0
    private var sharedConstraints: [NSLayoutConstraint] = []
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []

    // MARK: - Internal properties -
    var router: MovieDetailWireframeLogic?
    var interactor: MovieDetailBusinessLogic?

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        getData()
        layoutTrait(traitCollection: traitCollection)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        interactor?.checkIfIsFavorite()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }

    // MARK: - Private methods -
    private func getData() {
        showLoading()
        interactor?.fetchData()
    }

    private func addSubviews() {
        view.backgroundColor = Colors.defaultBackground
        titleContainer.addArrangedSubview(movieTitle)
        titleContainer.addArrangedSubview(favoriteImage)
        view.addSubview(movieImage)
        stackView.addArrangedSubview(titleContainer)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(movieYear)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(movieGender)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(movieBody)
        stackView.spacing = 10.0
        view.addSubview(stackView)
        sharedConstraints.append(contentsOf: [
            movieImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
            movieImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin),
            movieImage.heightAnchor.constraint(equalTo: movieImage.widthAnchor, multiplier: 0.56),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -margin),
            favoriteImage.widthAnchor.constraint(equalToConstant: 30.0),
            favoriteImage.heightAnchor.constraint(equalToConstant: 30.0)
        ])

        compactConstraints.append(contentsOf: [
            movieImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            stackView.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: margin),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin)
        ])
        regularConstraints.append(contentsOf: [
            movieImage.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -margin),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
            stackView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: margin)
        ])
        favoriteImage.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
    }

    private func createSeparator() -> UIView {
        let separator: UIView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 1.0)))
        separator.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        separator.backgroundColor = UIColor.gray
        return separator
    }

    private func layoutTrait(traitCollection: UITraitCollection) {
        if !sharedConstraints.isEmpty && !sharedConstraints[0].isActive {
           NSLayoutConstraint.activate(sharedConstraints)
        }
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if !regularConstraints.isEmpty && regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            if !compactConstraints.isEmpty && compactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            NSLayoutConstraint.activate(regularConstraints)
        }
    }

    // MARK: - Actions -
    @objc private func toggleFavorite() {
        if isFavorite {
            interactor?.deleteFavorite()
        } else {
            interactor?.saveFavorite()
        }
    }
}

// MARK: - MovieDetailDisplayLogic -
extension MovieDetailViewController: MovieDetailDisplayLogic {

    func displayViewModel(_ viewModel: MovieDetailViewModel) {
        self.title = viewModel.title
        movieTitle.text = viewModel.title
        movieBody.text = viewModel.body
        movieYear.text = viewModel.year
        movieGender.text = viewModel.genres
        if let imageUrl: URL = viewModel.backdropPath {
            movieImage.af.setImage(withURL: imageUrl)
        }
        hideLoading()
    }

    func displayIfIsFavorite(_ isFavorite: Bool) {
        hideLoading()
        self.isFavorite = isFavorite
    }
}
