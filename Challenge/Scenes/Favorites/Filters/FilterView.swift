//
//  FilterView.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 19/10/22.
//

import UIKit

class FilterView: UIView {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 25, bottom: 15, trailing: 20)
        return stackView
    }()
    private let separatorView: UIView = {
        let separator: UIView = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = Colors.tintColor
        return separator
    }()
    private let titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.subtitle
        label.textColor = Colors.defaultTextColor
        return label
    }()
    private let subtitleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .right
        label.font = Fonts.title
        label.textColor = Colors.tintColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let iconImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = Colors.defaultTextColor
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Colors.defaultBackground
        subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(iconImage)
        addSubview(stackView)
        addSubview(separatorView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            separatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    func setupLabels(name: String, value: String) {
        titleLabel.text = name
        subtitleLabel.text = value
    }

}
