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
        let isLarge = (label.font == UIFont.boldSystemFont(ofSize: 20))
        let size: CGFloat = contentView.frame.size.height - 20
        iconContainer.frame = CGRect(x: 15, y: 10, width: size, height: size)
        
        if isLarge {
            iconContainer.layer.cornerRadius = size / 2
        }
        
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
        iconContainer.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        accessoryType = .disclosureIndicator
        detailTextLabel?.text = nil
        
        label.font = UIFont.systemFont(ofSize: 16)
    }
    
    // Configure cell with SettingsOption model
    public func configure(with model: SettingsOption) {
        label.text = model.title
        iconImageView.image = model.icon
        
        if model.isLarge {
            label.font = UIFont.boldSystemFont(ofSize: 20)
        } else {
            label.font = UIFont.systemFont(ofSize: 16)
        }
        
        // Special logic for the Apple Intelligence section
        if model.icon == UIImage(systemName: "apple.intelligence") {
            if traitCollection.userInterfaceStyle == .light {
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = [
                    UIColor.systemYellow.cgColor,
                    UIColor.systemPink.cgColor,
                    UIColor.systemTeal.cgColor,
                ]
                gradientLayer.locations = [0.0, 0.5, 0.8]
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
                gradientLayer.frame = iconContainer.bounds
                gradientLayer.cornerRadius = iconContainer.layer.cornerRadius

                iconContainer.layer.insertSublayer(gradientLayer, at: 0)
                iconImageView.tintColor = .white
            } else {
                iconContainer.backgroundColor = .systemBackground
                iconImageView.image = gradientMaskedImage(for: model.icon)
            }
        } else {
            // Handle light and dark mode
            if traitCollection.userInterfaceStyle == .dark && !model.isLarge {
                iconContainer.backgroundColor = .systemBackground
                iconImageView.tintColor = model.iconBackgroundColor
            } else {
                iconContainer.backgroundColor = model.iconBackgroundColor
                iconImageView.tintColor = .white
            }
        }
        
        accessoryType = model.accessory
        detailTextLabel?.text = model.detailText
    }
}

// Create a yellow pink blue gradient
private func gradientMaskedImage(for image: UIImage?) -> UIImage? {
    guard let image = image else { return nil }
    
    let size = image.size
    let renderer = UIGraphicsImageRenderer(size: size)
    
    return renderer.image { context in
        let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: [
                UIColor.systemYellow.cgColor,
                UIColor.systemPink.cgColor,
                UIColor.systemTeal.cgColor,
                UIColor.systemCyan.cgColor,
            ] as CFArray,
            locations: [0.0, 0.5, 0.8, 1.0]
        )!

        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: size.width, y: size.height)
        context.cgContext.clip(to: CGRect(origin: .zero, size: size), mask: image.cgImage!)
        context.cgContext.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    }
}
