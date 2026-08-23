//
//  SwitchViewCell.swift
//  Settings
//
//  Created by Sachin Agrawal on 6/27/24.
//

import UIKit

class SwitchViewCell: UITableViewCell {

    // Reuse identifier for cell
    static let identifier = "SwitchViewCell"

    // Corner radius of a tile as a fraction of its side
    private static let tileCornerRatio: CGFloat = 0.225

    // Container view for icon with rounded corners
    private let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerCurve = .continuous
        view.layer.masksToBounds = true
        return view
    }()

    // ImageView for icon set to scale aspect fit and white tint color
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // Label for displaying setting title
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    // UISwitch for toggling setting
    private let mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.onTintColor = .systemGreen
        return mySwitch
    }()

    // Optional handlers for switch toggle actions
    private var switchHandler: ((UISwitch) -> Void)?

    // Reports the new value so the owner can persist it across cell reuse
    var stateDidChange: ((Bool) -> Void)?

    // Initializer to set up subviews and initial configurations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Add subviews to content view
        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.addSubview(mySwitch)

        contentView.clipsToBounds = true
        preservesSuperviewLayoutMargins = false
        accessoryType = .none

        // Add target action for switch toggle
        mySwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)

        // Re-resolve the icon colors the moment light and dark mode swap
        _ = registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (cell: SwitchViewCell, _: UITraitCollection) in
            cell.applyIconAppearance()
        }
    }

    // Required initializer fatalError to ensure this is not called
    required init?(coder: NSCoder) {
        fatalError()
    }

    // Layout subviews within cell
    override func layoutSubviews() {
        super.layoutSubviews()

        // Center a fixed tile size vertically and guard against a zero first layout height
        let size: CGFloat = max(0, min(SettingViewCell.tileSize, contentView.frame.size.height - 8))
        iconContainer.frame = CGRect(
            x: SettingViewCell.tileLeading,
            y: (contentView.frame.size.height - size) / 2,
            width: size,
            height: size
        )
        iconContainer.layer.cornerRadius = min(size * SwitchViewCell.tileCornerRatio, size / 2)

        // Size and position of icon image view
        let imageSize: CGFloat = size * 2 / 3
        iconImageView.frame = CGRect(x: (size - imageSize) / 2, y: (size - imageSize) / 2, width: imageSize, height: imageSize)

        // Position of switch
        mySwitch.sizeToFit()
        mySwitch.frame = CGRect(x: contentView.frame.size.width - mySwitch.frame.size.width - 15,
                                y: (contentView.frame.size.height - mySwitch.frame.size.height) / 2,
                                width: mySwitch.frame.size.width,
                                height: mySwitch.frame.size.height)

        // Position of label
        let textX = SettingViewCell.textInset(isLarge: false)
        label.frame = CGRect(
            x: textX,
            y: 0,
            width: max(0, mySwitch.frame.minX - textX - 10),
            height: contentView.frame.size.height
        )

        // Keep the hairline under the text rather than under the icon
        separatorInset = UIEdgeInsets(top: 0, left: textX, bottom: 0, right: 0)
    }

    // Prepare cell for reuse by resetting properties
    override func prepareForReuse() {
        super.prepareForReuse()

        label.text = nil
        iconImageView.image = nil
        iconContainer.backgroundColor = nil
        iconContainer.layer.cornerRadius = 0
        mySwitch.isOn = false
        mySwitch.isEnabled = true
        switchHandler = nil
        stateDidChange = nil
        setNeedsLayout()
    }

    // Configure cell with SettingsSwitchOption model
    public func configure(with model: SettingsSwitchOption) {
        label.text = model.title
        iconImageView.image = model.icon

        tileColor = model.iconBackgroundColor
        applyIconAppearance()

        mySwitch.isOn = model.isOn
        mySwitch.isEnabled = model.isEnabled
        switchHandler = model.handler

        setNeedsLayout()
    }

    // Base color of the current model kept so the appearance can be recomputed
    private var tileColor: UIColor = .systemGray

    // Resolve the tile colors for the trait collection in effect right now
    private func applyIconAppearance() {
        // Invert the tile in dark mode with a dark background and colored glyph
        if traitCollection.userInterfaceStyle == .dark {
            iconContainer.backgroundColor = .systemBackground
            iconImageView.tintColor = tileColor
        } else {
            iconContainer.backgroundColor = tileColor
            iconImageView.tintColor = .white
        }
    }

    // Action method called when switch is toggled
    @objc private func switchToggled() {
        // Persist first so a scroll away and back shows the value the user picked
        stateDidChange?(mySwitch.isOn)
        switchHandler?(mySwitch)
    }
}
