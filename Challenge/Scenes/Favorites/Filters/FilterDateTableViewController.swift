//
//  FilterDateTableViewController.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 19/10/22.
//

import UIKit

class FilterDateTableViewController: UITableViewController {

    // MARK: - Internal properties -
    weak var yearsDataSource: FilterDateDataSource?

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterTableViewCell")
    }

    // MARK: - Table view data source -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yearsDataSource?.years.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FilterTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let year = yearsDataSource?.years[indexPath.row] ?? 0
        cell.configureView(name: "\(year)")
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow,
            indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            yearsDataSource?.yearSelected = nil
            return nil
        }
        yearsDataSource?.yearSelected = yearsDataSource?.years[indexPath.row] ?? 0
        return indexPath
    }

    override func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let year = yearsDataSource?.years[indexPath.row] ?? 0
        if year == yearsDataSource?.yearSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
}
