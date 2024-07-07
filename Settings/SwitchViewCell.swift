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
    
    // UISwitch for toggling setting
    private let mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.onTintColor = .systemGreen
        return mySwitch
    }()

    // Optional handlers for switch toggle actions
    private var switchHandler: ((UISwitch) -> Void)?

    // Initializer to set up subviews and initial configurations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add subviews to content view
        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.addSubview(mySwitch)
        
        contentView.clipsToBounds = true
        accessoryType = .none
        
        // Add target action for switch toggle
        mySwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
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
        
        // Position of switch
        mySwitch.sizeToFit()
        mySwitch.frame = CGRect(x: contentView.frame.size.width - mySwitch.frame.size.width - 15,
                                y: (contentView.frame.size.height - mySwitch.frame.size.height) / 2,
                                width: mySwitch.frame.size.width,
                                height: mySwitch.frame.size.height)
        
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
        mySwitch.isOn = false
        mySwitch.isEnabled = true
        switchHandler = nil
    }
    
    // Configure cell with SettingsSwitchOption model
    public func configure(with model: SettingsSwitchOption) {
        label.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
        mySwitch.isOn = model.isOn
        mySwitch.isEnabled = model.isEnabled
        switchHandler = model.handler
    }
    
    // Action method called when switch is toggled
    @objc private func switchToggled() {
        switchHandler?(mySwitch)
    }
}
