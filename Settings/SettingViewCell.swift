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
    
    // Container view for icon with rounded corners
    private let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
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
    
    // Initializer to set up subviews and initial configurations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        // Add subviews to content view
        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        
        contentView.clipsToBounds = true
    }
    
    // Required initializer fatalError to ensure this is not called
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Layout subviews within cell
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Size and position of icon container
        let size: CGFloat = contentView.frame.size.height - 20
        iconContainer.frame = CGRect(x: 15, y: 10, width: size, height: size)
        
        // Size and position of icon image view
        let imageSize: CGFloat = size * 2 / 3
        iconImageView.frame = CGRect(x: (size - imageSize) / 2, y: (size - imageSize) / 2, width: imageSize, height: imageSize)
        
        // Position of label
        label.frame = CGRect(
            x: 25 + iconContainer.frame.size.width,
            y: 0,
            width: contentView.frame.size.width - 20 - iconContainer.frame.size.width,
            height: contentView.frame.size.height
        )
    }
    
    // Prepare cell for reuse by resetting properties
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        iconImageView.image = nil
        iconContainer.backgroundColor = nil
        accessoryType = .disclosureIndicator
        detailTextLabel?.text = nil
    }
    
    // Configure cell with SettingsOption model
    public func configure(with model: SettingsOption) {
        label.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
        accessoryType = model.accessory
        detailTextLabel?.text = model.detailText
    }
}
