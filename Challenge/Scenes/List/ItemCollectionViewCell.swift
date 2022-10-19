//
//  ItemCollectionViewCell.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 16/10/22.
//

import AlamofireImage
import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    private let movieImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let favoriteImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.tintColor = Colors.tintColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let movieTitle: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = Colors.defaultTextColor
        label.font = Fonts.title
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        backgroundColor = Colors.itemBackground
        addSubview(movieImage)
        addSubview(movieTitle)
        addSubview(favoriteImage)
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieImage.heightAnchor.constraint(equalTo: movieImage.widthAnchor),
            movieTitle.topAnchor.constraint(equalTo: movieImage.bottomAnchor),
            movieTitle.heightAnchor.constraint(equalToConstant: 40.0),
            movieTitle.bottomAnchor.constraint(equalTo: bottomAnchor),
            movieTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            movieTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            movieTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            favoriteImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            favoriteImage.centerYAnchor.constraint(equalTo: movieTitle.centerYAnchor),
            favoriteImage.widthAnchor.constraint(equalToConstant: 20.0),
            favoriteImage.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }

    func configureView(item: MovieViewModel) {
        movieTitle.isHidden = false
        movieImage.isHidden = false
        movieTitle.text = item.title
        if let imageUrl: URL = item.posterPath {
            movieImage.af.setImage(withURL: imageUrl)
        }
        favoriteImage.isHidden = !item.isFavorite
    }

    func configureViewEmpty() {
        movieTitle.isHidden = true
        movieImage.isHidden = true
    }
}
