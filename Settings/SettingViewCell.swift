//
//  SettingViewCell.swift
//  Settings
//
//  Created by Sachin Agrawal on 6/27/24.
//

import UIKit

class SettingViewCell: UITableViewCell {

    // Reuse identifier for cell
    static let identifier = "SettingViewCell"

    // Corner radius of a regular tile as a fraction of its side
    private static let tileCornerRatio: CGFloat = 0.225

    // Tile metrics kept independent of the row height so taller rows do not enlarge icons
    static let tileSize: CGFloat = 30
    static let largeTileSize: CGFloat = 60
    static let tileLeading: CGFloat = 15
    static let tileTextGap: CGFloat = 12

    // Where the text starts and where the separator should begin
    static func textInset(isLarge: Bool) -> CGFloat {
        return tileLeading + (isLarge ? largeTileSize : tileSize) + tileTextGap
    }

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
        return label
    }()

    // Label for the smaller line underneath the title
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()

    // Whether this cell is currently showing the tall account style
    private var isLarge = false

    // Whether the artwork is a finished app icon that fills the whole tile
    private var isAppIcon = false

    // Initializer to set up subviews and initial configurations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

        // Add subviews to content view
        contentView.addSubview(label)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)

        contentView.clipsToBounds = true
        preservesSuperviewLayoutMargins = false

        // Re-resolve the icon colors the moment light and dark mode swap
        _ = registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (cell: SettingViewCell, _: UITraitCollection) in
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
        let requested = isLarge ? SettingViewCell.largeTileSize : SettingViewCell.tileSize
        let size: CGFloat = max(0, min(requested, contentView.frame.size.height - 8))
        iconContainer.frame = CGRect(
            x: SettingViewCell.tileLeading,
            y: (contentView.frame.size.height - size) / 2,
            width: size,
            height: size
        )

        // Always assign the radius so a recycled cell drops the large circular value
        iconContainer.layer.cornerRadius = isLarge
            ? size / 2
            : min(size * SettingViewCell.tileCornerRatio, size / 2)

        // Size and position of icon image view
        let imageRatio: CGFloat = isAppIcon ? 0.74 : 2 / 3
        let imageSize: CGFloat = size * imageRatio
        iconImageView.frame = CGRect(x: (size - imageSize) / 2, y: (size - imageSize) / 2, width: imageSize, height: imageSize)

        // Position of labels
        let textX = SettingViewCell.textInset(isLarge: isLarge)
        let textWidth = max(0, contentView.frame.size.width - textX - 10)

        // Keep the hairline under the text rather than under the icon
        separatorInset = UIEdgeInsets(top: 0, left: textX, bottom: 0, right: 0)

        if isLarge, let subtitle = subtitleLabel.text, !subtitle.isEmpty {
            // Stack the title and its smaller line centered together
            let titleHeight: CGFloat = 24
            let subtitleHeight: CGFloat = 18
            let top = (contentView.frame.size.height - titleHeight - subtitleHeight) / 2

            label.frame = CGRect(x: textX, y: top, width: textWidth, height: titleHeight)
            subtitleLabel.frame = CGRect(x: textX, y: top + titleHeight, width: textWidth, height: subtitleHeight)
        } else {
            label.frame = CGRect(
                x: textX,
                y: 0,
                width: textWidth,
                height: contentView.frame.size.height
            )
            subtitleLabel.frame = .zero
        }
    }

    // Prepare cell for reuse by resetting properties
    override func prepareForReuse() {
        super.prepareForReuse()

        label.text = nil
        subtitleLabel.text = nil
        iconImageView.image = nil
        iconContainer.backgroundColor = nil
        accessoryType = .disclosureIndicator
        detailTextLabel?.text = nil

        label.font = UIFont.systemFont(ofSize: 16)

        // Reset every piece of geometry and styling the previous model may have changed
        isLarge = false
        isAppIcon = false
        iconContainer.layer.cornerRadius = 0
        iconContainer.alpha = 1
        label.textColor = .label
        subtitleLabel.textColor = .secondaryLabel
        detailTextLabel?.textColor = .secondaryLabel
        selectionStyle = .default
        setNeedsLayout()
    }

    // Configure cell with SettingsOption model
    public func configure(with model: SettingsOption) {
        label.text = model.title
        subtitleLabel.text = model.subtitle

        isLarge = model.isLarge
        isAppIcon = model.isAppIcon

        if model.isLarge {
            label.font = UIFont.boldSystemFont(ofSize: 20)
        } else {
            label.font = UIFont.systemFont(ofSize: 16)
        }

        // Keep app icons in their own colors and tint every other glyph
        if model.isAppIcon {
            iconImageView.image = model.icon?.withRenderingMode(.alwaysOriginal)
        } else {
            iconImageView.image = model.icon
        }

        tileColor = model.iconBackgroundColor
        applyIconAppearance()

        accessoryType = model.accessory
        detailTextLabel?.text = model.detailText

        // Grey the whole row out when the setting is unavailable
        label.textColor = model.isEnabled ? .label : .tertiaryLabel
        subtitleLabel.textColor = model.isEnabled ? .secondaryLabel : .tertiaryLabel
        detailTextLabel?.textColor = model.isEnabled ? .secondaryLabel : .tertiaryLabel
        iconContainer.alpha = model.isEnabled ? 1 : 0.4
        selectionStyle = model.isEnabled ? .default : .none

        setNeedsLayout()
    }

    // Base color of the current model kept so the appearance can be recomputed
    private var tileColor: UIColor = .systemGray

    // Resolve the tile colors for the trait collection in effect right now
    private func applyIconAppearance() {
        // Let UIKit re-resolve the dynamic tile that full color artwork sits on
        guard !isAppIcon else {
            iconContainer.backgroundColor = tileColor
            return
        }

        // Invert the tile in dark mode with a dark background and colored glyph
        if traitCollection.userInterfaceStyle == .dark && !isLarge {
            iconContainer.backgroundColor = .systemBackground
            iconImageView.tintColor = tileColor
        } else {
            iconContainer.backgroundColor = tileColor
            iconImageView.tintColor = .white
        }
    }
}
