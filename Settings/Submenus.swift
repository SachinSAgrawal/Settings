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
        tableView.frame = view.bounds
    }
    
    // Set up a text view for displaying static text
    func setupStaticTextView(_ text: String) {
        let textView = UITextView(frame: view.bounds)
        textView.text = text
        textView.font = .systemFont(ofSize: 16)
        textView.isEditable = false
        textView.backgroundColor = .systemBackground
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 72, right: 16)
        view.addSubview(textView)
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
