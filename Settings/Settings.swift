//
//  Settings.swift
//  Settings
//
//  Created by Sachin Agrawal on 6/27/24.
//

import UIKit

// MARK: Custom Structs

// Define a struct for sections in the settings table view
struct Section {
    let title: String
    var options: [SettingsOptionType]
    var footer: String
}

// Enum to differentiate between static cells and switch cells in the settings
enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
}

// Define a struct for switch options in the settings
struct SettingsSwitchOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: ((UISwitch) -> Void)?
    var isOn: Bool
    var isEnabled: Bool
}

// Define a struct for static options in the settings
struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let accessory: UITableViewCell.AccessoryType
    let detailText: String?
    let handler: (() -> Void)?
    let submenuSections: [SubmenuSection]?
    let staticText: String?
}

// Define a struct for submenu sections
struct SubmenuSection {
    let header: String
    let footer: String
    let options: [SubmenuOption]
}

// Define a struct for submenu options
struct SubmenuOption {
    let title: String
    let accessory: UITableViewCell.AccessoryType
    let detailText: String?
    let handler: (() -> Void)?
}

// Protocol for settings delegate to handle various settings actions
protocol SettingsDelegate {
    func updatedWifi(name: String)
    func airplaneMode(value: Bool)
}

// Main view controller for settings
class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: SettingsDelegate? = nil
    
    // Variables to hold the state of various settings
    var isAirplaneModeOn: Bool = true
    
    // Initialize the table view with an inset grouped style
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingViewCell.self,
                       forCellReuseIdentifier: SettingViewCell.identifier)
        table.register(SwitchViewCell.self,
                       forCellReuseIdentifier: SwitchViewCell.identifier)
        return table
    }()
    
    var models = [Section]()

    // MARK: View Loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsConfiguration()
        
        // Set the title and add the table view to the main view
        title = "Settings"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        // Add a footer view to the table with the commit hash
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        let commitHashLabel = UILabel()
        
        let commitHash = Bundle.main.commitHash ?? "Undefined"
        
        // Configure the label containing the commit hash
        commitHashLabel.text = "Hash: \(commitHash)"
        commitHashLabel.textAlignment = .center
        commitHashLabel.font = UIFont.systemFont(ofSize: 12)
        commitHashLabel.textColor = .lightGray
        
        let padding: CGFloat = 50
        commitHashLabel.frame = CGRect(x: 0, y: -25, width: footerView.frame.width, height: footerView.frame.height - padding)
        
        footerView.addSubview(commitHashLabel)
        
        tableView.tableFooterView = footerView
    }
    
    // Return the header title for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return models[section].title
    }
    
    // Return the footer text for each section
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return models[section].footer
    }
    
    // Return the number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }

    // Return the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    // Configure each cell based on the type of option
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
            
        case .staticCell(let model): // Static type
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingViewCell.identifier,
                for: indexPath
            ) as? SettingViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
            
        case .switchCell(let model): // Switch type
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchViewCell.identifier,
                for: indexPath
            ) as? SwitchViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }

    // MARK: Cell Selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        
        switch type.self {
            
        case .staticCell(let model):
            // Use the regular handler unless it should open a submenu
            if let submenuSections = model.submenuSections {
                let vc = SubmenuViewController()
                vc.submenuSections = submenuSections
                vc.title = model.title
                navigationController?.pushViewController(vc, animated: true)
            } else if let staticText = model.staticText {
                let vc = SubmenuViewController()
                vc.staticText = staticText
                vc.title = model.title
                navigationController?.pushViewController(vc, animated: true)
            } else {
                model.handler?()
            }
            
        case .switchCell:
            break
        }
    }
}

// MARK: Commit Hash
extension Bundle {
    var commitHash: String? {
        // Get the commit hash from the app's info dictionary
        infoDictionary?["GIT_COMMIT_HASH"] as? String
    }
}
