//
//  FilterGenresTableViewController.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 19/10/22.
//

import UIKit

class FilterGenresTableViewController: UITableViewController {

    // MARK: - Internal properties -
    weak var genresDataSource: FilterGenresDataSource?

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterTableViewCell")
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genresDataSource?.genres.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FilterTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let genre = genresDataSource?.genres[indexPath.row]
        cell.configureView(name: genre?.name ?? "")
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        genresDataSource?.genres[indexPath.row].isSelected = true
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        genresDataSource?.genres[indexPath.row].isSelected = false
    }

    override func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let genre = genresDataSource?.genres[indexPath.row]
        if genre?.isSelected == true {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
}
