//
//  Configuration.swift
//  Settings
//
//  Created by Sachin Agrawal on 6/27/24.
//

import UIKit

extension SettingsViewController {

    func settingsConfiguration() {
        let wifi: String = UserDefaults.standard.string(forKey: "wifi") ?? "127.0.0.1"

        models.append(Section(title: "", options: [
            .staticCell(model: SettingsOption(title: "John Appleseed", icon: UIImage(systemName: "person.fill"), iconBackgroundColor: .systemCyan, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "John Appleseed", message: "Apple Account, iCloud+, and more")
            }, submenuSections: nil, staticText: nil, isLarge: true, subtitle: "Apple Account, iCloud+, and more")),
            .staticCell(model: SettingsOption(title: "Family", icon: UIImage(systemName: "person.2.fill"), iconBackgroundColor: .systemYellow, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Family", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false))
        ], footer: ""))

        models.append(Section(title: "", options: [
            .staticCell(model: SettingsOption(title: "AirPods Pro", icon: UIImage(systemName: "airpods.pro"), iconBackgroundColor: .init(red: 0.7, green: 0.7, blue: 0.75, alpha: 1), accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "AirPods Pro", message: "Model Number A3048")
            }, submenuSections: nil, staticText: nil, isLarge: false))
        ], footer: ""))

        models.append(Section(title: "", options: [
            .switchCell(model: SettingsSwitchOption(key: "airplaneMode", title: "Airplane Mode", icon: UIImage(systemName: "airplane"), iconBackgroundColor: .systemOrange, handler: { [self] mySwitch in
                if delegate != nil {
                    isAirplaneModeOn = mySwitch.isOn
                    delegate!.airplaneMode(value: isAirplaneModeOn)
                }
            }, isOn: isAirplaneModeOn, isEnabled: true)),
            .staticCell(model: SettingsOption(title: "Wi-Fi", icon: UIImage(systemName: "wifi"), iconBackgroundColor: .systemBlue, accessory: .disclosureIndicator, detailText: wifi, handler: {
                self.saveWiFi(title: "Wi-Fi", message: "Enter network name:", placeholder: "127.0.0.1")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Bluetooth", icon: UIImage(named: "Bluetooth"), iconBackgroundColor: .systemBlue, accessory: .disclosureIndicator, detailText: "On", handler: {
                self.showAlert(title: "Bluetooth", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Cellular", icon: UIImage(systemName: "antenna.radiowaves.left.and.right"), iconBackgroundColor: .systemGreen, accessory: .disclosureIndicator, detailText: "Off", handler: {
                self.showAlert(title: "Cellular", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Personal Hotspot", icon: UIImage(systemName: "personalhotspot"), iconBackgroundColor: .systemGreen, accessory: .disclosureIndicator, detailText: "Off", handler: nil, submenuSections: nil, staticText: nil, isLarge: false, isEnabled: false)),
            .staticCell(model: SettingsOption(title: "Battery", icon: UIImage(systemName: "battery.100percent"), iconBackgroundColor: .systemGreen, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Battery", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false))
        ], footer: ""))

        models.append(Section(title: "", options: [
            .staticCell(model: SettingsOption(title: "General", icon: UIImage(systemName: "gear"), iconBackgroundColor: .systemGray, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "General", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Accessibility", icon: UIImage(systemName: "accessibility"), iconBackgroundColor: .systemBlue, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Accessibility", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Action Button", icon: UIImage(systemName: "arrow.turn.up.forward.iphone"), iconBackgroundColor: .systemBlue, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Action Button", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Appearance", icon: .appearanceGlyph(), iconBackgroundColor: .systemGray, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Appearance", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Camera", icon: UIImage(systemName: "camera.fill"), iconBackgroundColor: .systemGray, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Camera", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Control Center", icon: UIImage(systemName: "switch.2"), iconBackgroundColor: .systemGray, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Control Center", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Display & Brightness", icon: UIImage(systemName: "sun.max.fill"), iconBackgroundColor: .systemBlue, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Display & Brightness", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Home Screen & App Library", icon: UIImage(systemName: "apps.iphone"), iconBackgroundColor: .systemBlue, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Home Screen & App Library", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Search", icon: UIImage(systemName: "magnifyingglass"), iconBackgroundColor: .systemGray, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Search", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Siri", icon: UIImage(named: "siri"), iconBackgroundColor: .appIconTile, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Siri", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false, isAppIcon: true)),
            .staticCell(model: SettingsOption(title: "Standby", icon: UIImage(systemName: "deskclock.fill"), iconBackgroundColor: .init(red: 0.65, green: 0.65, blue: 0.7, alpha: 1), accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Standby", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Wallpaper", icon: UIImage(systemName: "atom"), iconBackgroundColor: .systemTeal, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Wallpaper", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false))
        ], footer: ""))

        models.append(Section(title: "", options: [
            .staticCell(model: SettingsOption(title: "Notifications", icon: UIImage(systemName: "bell.badge.fill"), iconBackgroundColor: .systemRed, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Notifications", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Sounds & Haptics", icon: UIImage(systemName: "speaker.wave.3.fill"), iconBackgroundColor: .systemPink, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Sounds & Haptics", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Focus", icon: UIImage(systemName: "moon.fill"), iconBackgroundColor: .systemIndigo, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Focus", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Screen Time", icon: UIImage(systemName: "hourglass"), iconBackgroundColor: .systemIndigo, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Screen Time", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false))
        ], footer: ""))

        models.append(Section(title: "", options: [
            .staticCell(model: SettingsOption(title: "Face ID & Passcode", icon: UIImage(systemName: "faceid"), iconBackgroundColor: .systemGreen, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Face ID & Passcode", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Emergency SOS", icon: UIImage(systemName: "sos"), iconBackgroundColor: .systemRed, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Emergency SOS", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "Privacy & Security", icon: UIImage(systemName: "hand.raised.fill"), iconBackgroundColor: .systemBlue, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Privacy & Security", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false))
        ], footer: ""))

        models.append(Section(title: "", options: [
            .staticCell(model: SettingsOption(title: "Game Center", icon: UIImage(named: "gamecenter"), iconBackgroundColor: .secondarySystemBackground, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Game Center", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false)),
            .staticCell(model: SettingsOption(title: "iCloud", icon: UIImage(named: "icloud"), iconBackgroundColor: .appIconTile, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "iCloud", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false, isAppIcon: true)),
            .staticCell(model: SettingsOption(title: "Wallet & Apple Pay", icon: UIImage(named: "applewallet"), iconBackgroundColor: .init(red: 0.13, green: 0.13, blue: 0.15, alpha: 1), accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Wallet & Apple Pay", message: "Placeholder")
            }, submenuSections: nil, staticText: nil, isLarge: false))
        ], footer: ""))

        models.append(Section(title: "", options: [
            .staticCell(model: SettingsOption(title: "Information", icon: UIImage(systemName: "info.circle"), iconBackgroundColor: .init(red: 0.75, green: 0.75, blue: 0.8, alpha: 1), accessory: .detailButton, detailText: nil, handler: {
                self.showAlert(title: "Information", message: "Placeholder")
            }, submenuSections: nil, staticText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla venenatis purus eu elit laoreet, id convallis lectus consequat. Pellentesque id mi neque. Duis eget pulvinar eros. Nam ornare hendrerit massa eu sodales. Morbi eget magna at lorem placerat tempus. Duis vel sollicitudin diam, vitae blandit enim. Curabitur eros elit, vehicula at interdum in, elementum lobortis urna. Sed ornare rhoncus risus, a ultrices risus maximus vitae. \n\nNullam aliquet ultrices nulla, eu luctus odio sollicitudin nec. Suspendisse vestibulum bibendum metus sed euismod. Ut elementum consequat ligula, vel lobortis enim viverra ut. Suspendisse commodo, nibh quis posuere auctor, lorem augue malesuada nunc, a dignissim massa ante condimentum risus. Donec condimentum interdum blandit. Curabitur velit orci, feugiat vitae convallis quis, vestibulum eu libero. Phasellus bibendum dignissim eros, sed tempus lorem condimentum vel. Donec eget ullamcorper odio, nec tempor orci. Nunc eget nunc nisl. Maecenas tempor facilisis felis, vitae imperdiet nisl euismod sit amet. \n\nPhasellus at finibus mi, sed accumsan eros. Proin hendrerit risus in nunc feugiat, vitae maximus turpis posuere. Morbi mi elit, sagittis nec placerat et, aliquet vel ante. Aliquam ac urna vel massa laoreet maximus vitae non ipsum. Sed quis augue est. Praesent ac ornare neque. Nullam dictum sem eget tincidunt hendrerit. Sed a neque cursus, finibus mi nec, ullamcorper turpis. Proin elementum, risus vitae posuere varius, urna nisl lobortis lectus, at faucibus leo lectus non velit. Phasellus dignissim suscipit nisi et elementum. Nulla vehicula porttitor turpis ac tristique. Phasellus eleifend mauris ex, sit amet feugiat elit porttitor sed. Donec blandit elementum orci, id consectetur elit vestibulum.", isLarge: false))
        ], footer: ""))

        models.append(Section(title: "", options: [
            .staticCell(model: SettingsOption(title: "Credits", icon: UIImage(systemName: "person.crop.circle"), iconBackgroundColor: .systemBrown, accessory: .detailButton, detailText: nil, handler: nil, submenuSections: [
                SubmenuSection(header: "Developers", footer: "Tap on a name to view their Github.", options: [
                    SubmenuOption(title: "Sachin Agrawal", accessory: .none, detailText: "Role", handler: {
                        if let url = URL(string: "https://github.com/SachinSAgrawal") {
                            UIApplication.shared.open(url)
                        }
                    }),
                    SubmenuOption(title: "Person 2", accessory: .none, detailText: "Role", handler: {
                        if let url = URL(string: "https://example.com") {
                            UIApplication.shared.open(url)
                        }
                    }),
                    SubmenuOption(title: "Person 3", accessory: .none, detailText: "Role", handler: {
                        if let url = URL(string: "https://example.com") {
                            UIApplication.shared.open(url)
                        }
                    })
                ]),
                SubmenuSection(header: "SDKs", footer: "", options: [
                    SubmenuOption(title: "UIKit", accessory: .disclosureIndicator, detailText: nil, handler: {
                        self.showAlert(title: "UIKit", message: "Construct and manage a graphical, event-driven user interface for your iOS, iPadOS, or tvOS app.")
                    }),
                    SubmenuOption(title: "Swift", accessory: .disclosureIndicator, detailText: nil, handler: {
                        self.showAlert(title: "Swift", message: "A powerful and intuitive programming language for all Apple platforms.")
                    })
                ])
            ], staticText: nil, isLarge: false))
        ], footer: ""))
    }

    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    func saveWiFi(title: String, message: String, placeholder: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = placeholder
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let textField = alert.textFields?.first, let text = textField.text, !text.isEmpty {
                UserDefaults.standard.setValue(text, forKey: "wifi")

                if self.delegate != nil {
                    self.delegate!.updatedWifi(name: text)
                }

                self.reloadWifiCell()
            }
        }

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    func reloadWifiCell() {
        // Look the row up instead of hardcoding indices that shift as sections change
        guard let location = indexPath(forOptionTitled: "Wi-Fi") else { return }

        models[location.section].options[location.row] = .staticCell(model: SettingsOption(title: "Wi-Fi", icon: UIImage(systemName: "wifi"), iconBackgroundColor: .systemBlue, accessory: .disclosureIndicator, detailText: UserDefaults.standard.string(forKey: "wifi"), handler: {
            self.saveWiFi(title: "Wi-Fi", message: "Enter network name:", placeholder: "127.0.0.1")
        }, submenuSections: nil, staticText: nil, isLarge: false))

        // Reload everything while searching since the table shows a filtered copy
        if isSearching {
            tableView.reloadData()
        } else {
            tableView.reloadRows(at: [location], with: .fade)
        }
    }

    // Find where an option lives in models by its title
    private func indexPath(forOptionTitled title: String) -> IndexPath? {
        for (sectionIndex, section) in models.enumerated() {
            for (rowIndex, option) in section.options.enumerated() {
                let optionTitle: String
                switch option {
                case .staticCell(let model): optionTitle = model.title
                case .switchCell(let model): optionTitle = model.title
                }

                if optionTitle == title {
                    return IndexPath(row: rowIndex, section: sectionIndex)
                }
            }
        }
        return nil
    }
}
