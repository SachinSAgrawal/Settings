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
    // Stable identity so the toggle state can be tracked across cell reuse
    let key: String
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
    var isLarge: Bool

    // Secondary line rendered underneath the title
    var subtitle: String? = nil

    // Artwork that is already a finished app icon so it fills the tile untinted
    var isAppIcon: Bool = false

    // A greyed out row that cannot be tapped
    var isEnabled: Bool = true
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
class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var delegate: SettingsDelegate? = nil

    // Variables to hold the state of various settings
    var isAirplaneModeOn: Bool = true

    // Live state of every switch keyed by its option key since cells are recycled
    var switchStates: [String: Bool] = [:]

    // Initialize the table view with an inset grouped style
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingViewCell.self,
                       forCellReuseIdentifier: SettingViewCell.identifier)
        table.register(SwitchViewCell.self,
                       forCellReuseIdentifier: SwitchViewCell.identifier)
        table.keyboardDismissMode = .onDrag
        return table
    }()

    // Floating search field that hovers above the bottom of the screen
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search"
        bar.searchBarStyle = .minimal
        bar.backgroundImage = UIImage()
        bar.autocapitalizationType = .none
        bar.autocorrectionType = .no
        bar.returnKeyType = .search
        bar.enablesReturnKeyAutomatically = false
        return bar
    }()

    // Give the shadow its own wrapper since the blur has to clip its own backdrop
    private let searchShadow: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 12
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()

    private let searchContainer: UIVisualEffectView = {
        let view: UIVisualEffectView

        if #available(iOS 26.0, *) {
            // Liquid glass that reacts to whatever scrolls underneath it
            let glass = UIGlassEffect(style: .regular)
            glass.isInteractive = true
            view = UIVisualEffectView(effect: glass)
            view.cornerConfiguration = .capsule()
        } else {
            view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
            view.layer.cornerCurve = .continuous
            view.layer.borderWidth = 0.5
        }

        view.clipsToBounds = true
        return view
    }()

    // Glass draws its own edge and shading so only the blur fallback needs a shadow
    private var usesGlass: Bool {
        if #available(iOS 26.0, *) { return true }
        return false
    }

    private var searchBottomConstraint: NSLayoutConstraint?

    // Height of the floating field plus the gap above and below it
    private let searchFieldHeight: CGFloat = 44
    private let searchFieldMargin: CGFloat = 12

    // Gap between the floating field and either side of the screen
    private let searchFieldInset: CGFloat = 36

    // Extra lift on the field alone that leaves the commit hash where it is
    private let searchFieldLift: CGFloat = 8

    // How far the field floats above the bottom of the safe area
    private var searchFieldBottomMargin: CGFloat {
        return searchFieldMargin + searchFieldLift
    }

    // Gap between the bottom of the floating field and the commit hash
    private let hashLabelGap: CGFloat = 8

    // Commit hash that rides at the very bottom of the table content
    private let hashFooter = UIView()
    private let hashLabel = UILabel()
    private var hashLabelCenterConstraint: NSLayoutConstraint?

    var models = [Section]()

    // Populated only while a search is active
    var filteredModels: [Section]? = nil

    // The sections actually driving the table right now
    var displayedModels: [Section] {
        return filteredModels ?? models
    }

    var isSearching: Bool {
        return filteredModels != nil
    }

    // MARK: View Loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsConfiguration()

        // Set the title and add the table view to the main view
        title = "Settings"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        // Add a back button to go back to the main app
        let backbutton = UIButton(type: .system)

        // Use UIButtonConfiguration for styling
        var config = UIButton.Configuration.plain()
        config.title = "Close"
        config.baseForegroundColor = backbutton.tintColor
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        backbutton.configuration = config
        backbutton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)

        // Use Auto Layout to ensure the table view fits within the safe area
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        setupSearchBar()

        setupCommitHashFooter()
    }

    // MARK: Commit Hash Footer

    // Clear the floating field with the footer and park the hash at its bottom
    private func setupCommitHashFooter() {
        let commitHash = Bundle.main.commitHash ?? "Undefined"

        // Configure the label containing the commit hash
        hashLabel.text = "Hash: \(commitHash)"
        hashLabel.textAlignment = .center
        hashLabel.font = UIFont.systemFont(ofSize: 10)
        hashLabel.textColor = .lightGray
        hashLabel.translatesAutoresizingMaskIntoConstraints = false

        hashFooter.addSubview(hashLabel)

        let center = hashLabel.centerYAnchor.constraint(equalTo: hashFooter.bottomAnchor)
        hashLabelCenterConstraint = center

        NSLayoutConstraint.activate([
            hashLabel.centerXAnchor.constraint(equalTo: hashFooter.centerXAnchor),
            center
        ])

        tableView.tableFooterView = hashFooter
        updateHashFooterMetrics()
    }

    private func updateHashFooterMetrics() {
        let safeBottom = view.safeAreaInsets.bottom

        // Strip of screen left over below the floating field
        let stripBelowField = safeBottom + searchFieldMargin

        // Clear the field and its margins then reach down past the safe area
        let height = searchFieldHeight + searchFieldMargin * 2 + searchFieldLift + safeBottom

        if hashFooter.frame.height != height {
            hashFooter.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: height)

            // The table only picks up a new footer height on assignment
            tableView.tableFooterView = hashFooter
        }

        // Tuck the hash just under the field rather than centering it in the strip
        let halfLine = hashLabel.font.lineHeight / 2
        hashLabelCenterConstraint?.constant = -max(halfLine, stripBelowField - hashLabelGap - halfLine)

        // Cancel the safe area inset so the footer can run to the screen edge
        tableView.contentInset.bottom = -safeBottom
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        updateHashFooterMetrics()
    }

    // MARK: Floating Search Field
    private func setupSearchBar() {
        searchBar.delegate = self

        // Let the capsule be the only rounded background so the search bar draws none
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.borderStyle = .none
        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)

        view.addSubview(searchShadow)
        searchShadow.addSubview(searchContainer)
        searchContainer.contentView.addSubview(searchBar)

        searchShadow.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        let bottom = searchShadow.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -searchFieldBottomMargin
        )
        searchBottomConstraint = bottom

        NSLayoutConstraint.activate([
            searchShadow.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: searchFieldInset),
            searchShadow.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -searchFieldInset),
            searchShadow.heightAnchor.constraint(equalToConstant: searchFieldHeight),
            bottom,

            searchContainer.leadingAnchor.constraint(equalTo: searchShadow.leadingAnchor),
            searchContainer.trailingAnchor.constraint(equalTo: searchShadow.trailingAnchor),
            searchContainer.topAnchor.constraint(equalTo: searchShadow.topAnchor),
            searchContainer.bottomAnchor.constraint(equalTo: searchShadow.bottomAnchor),

            searchBar.leadingAnchor.constraint(equalTo: searchContainer.contentView.leadingAnchor, constant: 4),
            searchBar.trailingAnchor.constraint(equalTo: searchContainer.contentView.trailingAnchor, constant: -4),
            searchBar.centerYAnchor.constraint(equalTo: searchContainer.contentView.centerYAnchor),
            searchBar.heightAnchor.constraint(equalTo: searchContainer.contentView.heightAnchor)
        ])

        applySearchFieldAppearance()

        // Refresh CGColor and shadow values by hand since they do not resolve dynamically
        _ = registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (vc: SettingsViewController, _: UITraitCollection) in
            vc.applySearchFieldAppearance()
        }

        // Keep the scroll indicator clear of the floating field
        tableView.verticalScrollIndicatorInsets.bottom = searchFieldHeight + searchFieldMargin + searchFieldBottomMargin

        // Slide the field up and down with the keyboard
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardFrameWillChange(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func applySearchFieldAppearance() {
        guard !usesGlass else { return }

        searchContainer.layer.cornerRadius = searchFieldHeight / 2
        searchContainer.layer.borderColor = UIColor.separator.cgColor
        searchShadow.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.45 : 0.15
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard !usesGlass else { return }

        // Give the layer an explicit path since a clear view casts no shadow on its own
        searchShadow.layer.shadowPath = UIBezierPath(
            roundedRect: searchShadow.bounds,
            cornerRadius: searchFieldHeight / 2
        ).cgPath
    }

    @objc private func keyboardFrameWillChange(_ notification: Notification) {
        guard let frameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardFrame = view.convert(frameValue.cgRectValue, from: nil)
        let overlap = max(0, view.bounds.maxY - keyboardFrame.minY - view.safeAreaInsets.bottom)

        animateSearchField(to: -(overlap + searchFieldBottomMargin), with: notification)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        animateSearchField(to: -searchFieldBottomMargin, with: notification)
    }

    private func animateSearchField(to constant: CGFloat, with notification: Notification) {
        searchBottomConstraint?.constant = constant

        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: Searching
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applyFilter(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    private func applyFilter(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            filteredModels = nil
            tableView.reloadData()
            return
        }

        // Flatten every row down to the ones whose title matches
        let matches = models
            .flatMap { $0.options }
            .filter { option in
                let title: String
                switch option {
                case .staticCell(let model): title = model.title
                case .switchCell(let model): title = model.title
                }
                return title.range(of: trimmed, options: [.caseInsensitive, .diacriticInsensitive]) != nil
            }

        filteredModels = [Section(title: "", options: matches, footer: matches.isEmpty ? "No Results" : "")]
        tableView.reloadData()
    }

    // Go to the previous view controller when the button is pressed
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    // Return the header title for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return displayedModels[section].title
    }

    // Return the footer text for each section
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return displayedModels[section].footer
    }

    // Adjust the height of the table as needed
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = displayedModels[indexPath.section].options[indexPath.row]

        switch model {
        case .staticCell(let model):
            return model.isLarge ? 88 : 56
        case .switchCell:
            return 56
        }
    }

    // Block selection on rows that are greyed out
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if case .staticCell(let model) = displayedModels[indexPath.section].options[indexPath.row],
           !model.isEnabled {
            return nil
        }
        return indexPath
    }

    // Return the number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return displayedModels.count
    }

    // Return the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedModels[section].options.count
    }

    // Configure each cell based on the type of option
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = displayedModels[indexPath.section].options[indexPath.row]

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

        case .switchCell(var model): // Switch type
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchViewCell.identifier,
                for: indexPath
            ) as? SwitchViewCell else {
                return UITableViewCell()
            }

            // Always show the live value rather than the one baked into the model
            model.isOn = switchStates[model.key] ?? model.isOn
            cell.configure(with: model)

            let key = model.key
            cell.stateDidChange = { [weak self] isOn in
                self?.switchStates[key] = isOn
            }
            return cell
        }
    }

    // MARK: Cell Selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = displayedModels[indexPath.section].options[indexPath.row]

        switch type.self {

        case .staticCell(let model):
            guard model.isEnabled else { return }

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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Icon Tiles
extension UIColor {
    // Tile behind full color artwork matching the grey in light mode and black in dark
    static let appIconTile = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor.systemBackground.resolvedColor(with: traits)
            : UIColor.secondarySystemBackground.resolvedColor(with: traits)
    }
}

// MARK: Appearance Glyph
extension UIImage {
    // Three concentric circles whose fill alternates outward and side to side
    static func appearanceGlyph(size: CGFloat = 100) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))

        let image = renderer.image { context in
            let cg = context.cgContext
            cg.setFillColor(UIColor.black.cgColor)

            let center = CGPoint(x: size / 2, y: size / 2)
            let outer = size / 2
            let middle = outer - size * 0.075
            let inner = outer * 0.42

            func circle(_ radius: CGFloat) -> CGPath {
                return CGPath(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius,
                                                width: radius * 2, height: radius * 2), transform: nil)
            }

            // Even odd turns the two circles into the ring between them
            func fillBand(from outerRadius: CGFloat, to innerRadius: CGFloat) {
                let path = CGMutablePath()
                path.addPath(circle(outerRadius))
                path.addPath(circle(innerRadius))
                cg.addPath(path)
                cg.fillPath(using: .evenOdd)
            }

            // Fill the outermost band all the way around
            fillBand(from: outer, to: middle)

            // Fill the next band inward on the left half only
            cg.saveGState()
            cg.clip(to: CGRect(x: 0, y: 0, width: center.x, height: size))
            fillBand(from: middle, to: inner)
            cg.restoreGState()

            // Fill the innermost circle on the right half only
            cg.saveGState()
            cg.clip(to: CGRect(x: center.x, y: 0, width: center.x, height: size))
            cg.addPath(circle(inner))
            cg.fillPath()
            cg.restoreGState()
        }

        // Template so it picks up the same tint every other glyph uses
        return image.withRenderingMode(.alwaysTemplate)
    }
}

// MARK: Commit Hash
extension Bundle {
    var commitHash: String? {
        // Get the commit hash from the app's info dictionary
        infoDictionary?["GIT_COMMIT_HASH"] as? String
    }
}
