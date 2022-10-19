//
//  ItemCollectionViewCell.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 16/10/22.
//

import AlamofireImage
import UIKit

final class FavoriteTableViewCell: UITableViewCell {

    private let movieImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let movieTitle: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = Colors.defaultTextColor
        label.font = Fonts.title
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let movieYear: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = Colors.defaultTextColor
        label.font = Fonts.info
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let movieBody: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = Colors.defaultTextColor
        label.font = Fonts.paragraph
        label.textAlignment = .justified
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var sharedConstraints: [NSLayoutConstraint] = []
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []

    // MARK: - Module setup -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        layoutTrait(traitCollection: traitCollection)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        backgroundColor = Colors.itemBackground
        addSubview(movieImage)
        addSubview(movieTitle)
        addSubview(movieYear)
        addSubview(movieBody)

        sharedConstraints.append(contentsOf: [
            movieImage.topAnchor.constraint(equalTo: topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            movieImage.heightAnchor.constraint(equalTo: movieImage.widthAnchor, multiplier: 1.5),

            movieTitle.topAnchor.constraint(equalTo: topAnchor, constant: 15.0),
            movieTitle.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 15.0),
            movieTitle.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -70.0),

            movieYear.topAnchor.constraint(equalTo: topAnchor, constant: 15.0),
            movieYear.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20.0),

            movieBody.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 8.0),
            movieBody.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 15.0),
            movieBody.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15.0),

            movieImage.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 0),
            movieBody.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
        ])

        regularConstraints.append(contentsOf: [
            movieImage.widthAnchor.constraint(equalToConstant: 80.0)
        ])

        compactConstraints.append(contentsOf: [
            movieImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25)
        ])
    }

    func configureView(item: FavoriteMovieViewModel) {
        movieTitle.text = item.title
        movieYear.text = item.year
        movieBody.text = item.overview
        if let imageUrl: URL = item.posterPath {
            movieImage.af.setImage(withURL: imageUrl)
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
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
}
