//
//  FilterTableViewCell.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 19/10/22.
//

import UIKit

final class FilterTableViewCell: UITableViewCell {

    // MARK: - Private properties -
    private let filterTitle: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = Colors.defaultTextColor
        label.font = Fonts.title
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let iconImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = Colors.tintColor
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Module setup -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        iconImage.isHidden = !selected
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods -
    private func addSubviews() {
        addSubview(filterTitle)
        addSubview(iconImage)
        NSLayoutConstraint.activate([
            filterTitle.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            filterTitle.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            filterTitle.trailingAnchor.constraint(equalTo: iconImage.leadingAnchor, constant: -10),
            filterTitle.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            iconImage.widthAnchor.constraint(equalToConstant: 20.0),
            iconImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }

    // MARK: - Internal methods -
    func configureView(name: String) {
        filterTitle.text = name
    }
}
