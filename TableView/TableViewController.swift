//
//  TableViewController.swift
//  TableView
//
//  Created by Garric G. Nahapetian on 5/17/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var items: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(
            self,
            action: #selector(didPullToRefresh),
            for: .valueChanged
        )

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapTrashButton))
        navigationItem.leftBarButtonItems = [addButton, trashButton]
        navigationItem.rightBarButtonItem = editButtonItem

        let frame = CGRect(
            x: 0,
            y: 0,
            width: CGFloat.ulpOfOne,
            height: CGFloat.ulpOfOne
        )

        let headerLabel = UILabel()
        headerLabel.text = "Awesome!"
        headerLabel.sizeToFit()
        tableView.tableHeaderView = headerLabel
        tableView.tableFooterView = UIView(frame: frame)
        tableView.backgroundColor = .green

        let otherLabel = UILabel()
        otherLabel.text = "Easter Egg!"
        otherLabel.textAlignment = .right
        tableView.addSubview(otherLabel)
        otherLabel.translatesAutoresizingMaskIntoConstraints = false
        otherLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        otherLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: -20).isActive = true
    }

    @objc private func didTapAddButton(sender: UIBarButtonItem) {
        items.insert("cool", at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        if items.count == 1 {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }

    @objc private func didTapTrashButton(sender: UIBarButtonItem) {
        items.removeAll()
        tableView.reloadData()
    }

    @objc private func didPullToRefresh(sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            sender.endRefreshing()
        }
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.isEmpty ? 1 : items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") ?? UITableViewCell(style: .default, reuseIdentifier: "myCell")

        let text: String

        if items.isEmpty {
            text = "Add an Item"
        } else {
            text = items[indexPath.row]
        }

        cell.textLabel?.text = text
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .insert:
            items.append("Item \(indexPath.row)")
            if items.count == 1 {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            items.remove(at: indexPath.row)
            if items.isEmpty {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .none: break
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return !items.isEmpty
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let popped = items.remove(at: sourceIndexPath.row)
        items.insert(popped, at: destinationIndexPath.row)
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if items.isEmpty {
            return .insert
        } else {
            return .delete
        }
    }
}
