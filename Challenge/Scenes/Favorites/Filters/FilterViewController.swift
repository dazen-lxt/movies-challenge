//
//  FilterViewController.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 19/10/22.
//

import UIKit

class FilterViewController: UIViewController, FilterDateDataSource, FilterGenresDataSource {

    // MARK: - Private properties -
    private let filterDate: FilterView = {
        let filter = FilterView()
        filter.translatesAutoresizingMaskIntoConstraints = false
        return filter
    }()
    private let filterGenres: FilterView = {
        let filter = FilterView()
        filter.translatesAutoresizingMaskIntoConstraints = false
        return filter
    }()
    private let applyButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = Fonts.subtitle
        button.backgroundColor = Colors.tintColor
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Internal properties -
    var genres: [IdNameSelectModel] = []
    var years: [Int] = []
    var yearSelected: Int?
    weak var delegate: FilterDelegate?

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLabels()
    }

    // MARK: - Private methods -
    private func addSubViews() {
        view.backgroundColor = Colors.defaultBackground
        view.addSubview(filterDate)
        view.addSubview(filterGenres)
        view.addSubview(applyButton)
        NSLayoutConstraint.activate([
            filterDate.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterDate.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            filterDate.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            filterGenres.topAnchor.constraint(equalTo: filterDate.bottomAnchor),
            filterGenres.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            filterGenres.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            applyButton.heightAnchor.constraint(equalToConstant: 40.0),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            applyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            applyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        let tapDate = UITapGestureRecognizer(target: self, action: #selector(self.handleDateTap(_:)))
        filterDate.addGestureRecognizer(tapDate)
        let tapGenres = UITapGestureRecognizer(target: self, action: #selector(self.handleGenresTap(_:)))
        filterGenres.addGestureRecognizer(tapGenres)
        applyButton.addTarget(self, action: #selector(applyButtonPressed), for: .touchUpInside)
    }

    private func updateLabels() {
        var yearString = ""
        if let year = yearSelected {
            yearString = "\(year)"
        }
        let genres: String = genres.filter { $0.isSelected }.map { $0.name }.joined(separator: ", ")
        filterDate.setupLabels(name: "Date", value: yearString)
        filterGenres.setupLabels(name: "Genred", value: genres)
    }

    // MARK: - Actions -
    @objc func handleDateTap(_ sender: UITapGestureRecognizer? = nil) {
        let filterDateTableViewController = FilterDateTableViewController()
        filterDateTableViewController.yearsDataSource = self
        navigationController?.pushViewController(filterDateTableViewController, animated: true)
    }

    @objc func handleGenresTap(_ sender: UITapGestureRecognizer? = nil) {
        let filterGenresTableViewController = FilterGenresTableViewController()
        filterGenresTableViewController.genresDataSource = self
        navigationController?.pushViewController(filterGenresTableViewController, animated: true)
    }

    @objc private func applyButtonPressed() {
        let genresSelected = genres.filter { $0.isSelected }.map { $0.id }
        delegate?.updateFilters(yearSelected: yearSelected, genresSelected: genresSelected)
        navigationController?.popViewController(animated: true)
    }
}

protocol FilterDateDataSource: AnyObject {
    var years: [Int] { get }
    var yearSelected: Int? { get  set}
}

protocol FilterGenresDataSource: AnyObject {
    var genres: [IdNameSelectModel] { get set }
}

protocol FilterDelegate: AnyObject {
    func updateFilters(yearSelected: Int?, genresSelected: [Int])
}
