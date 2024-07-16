//
//  Submenus.swift
//  Settings
//
//  Created by Sachin Agrawal on 7/1/24.
//

import UIKit

class SubmenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var submenuSections: [SubmenuSection]?
    var staticText: String?

    // Initialize the table view with an inset grouped style
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        // Set up either static text view or table view based on staticText
        if let staticText = staticText {
            setupStaticTextView(staticText)
        } else {
            setupTableView()
        }
    }

    // Set up the table view
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Use Auto Layout to ensure the table view fits within the safe area
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // Set up a text view for displaying static text
    func setupStaticTextView(_ text: String) {
        let textView = UITextView()
        textView.text = text
        textView.font = .systemFont(ofSize: 16)
        textView.isEditable = false
        textView.backgroundColor = .systemBackground
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
        view.addSubview(textView)
        
        // Use Auto Layout to ensure the table view fits within the safe area
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    // Return the number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return submenuSections?.count ?? 0
    }

    // Return the header title for a section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return submenuSections?[section].header
    }

    // Return the footer title for a section
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return submenuSections?[section].footer
    }

    // Return the number of rows in a section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return submenuSections?[section].options.count ?? 0
    }

    // Configure and return the cell for a row at an index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        if let option = submenuSections?[indexPath.section].options[indexPath.row] {
            cell.textLabel?.text = option.title
            cell.accessoryType = option.accessory
            cell.detailTextLabel?.text = option.detailText
        }
        return cell
    }

    // Handle row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let option = submenuSections?[indexPath.section].options[indexPath.row] {
            option.handler?()
        }
    }
}
