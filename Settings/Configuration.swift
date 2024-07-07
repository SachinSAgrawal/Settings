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
        
        models.append(Section(title: "Information", options: [
            .staticCell(model: SettingsOption(title: "Airpods", icon: UIImage(systemName: "airpods"), iconBackgroundColor: .systemGray, accessory: .none, detailText: nil, handler: {
                self.showAlert(title: "Airpods", message: "Blank")
            }, submenuSections: nil, staticText: nil))
        ], footer: "Model Number A2031"))
        
        models.append(Section(title: "General", options: [
            .switchCell(model: SettingsSwitchOption(title: "Airplane Mode", icon: UIImage(systemName: "airplane"), iconBackgroundColor: .systemOrange, handler: { [self] mySwitch in
                if delegate != nil {
                    isAirplaneModeOn = mySwitch.isOn
                    delegate!.airplaneMode(value: isAirplaneModeOn)
                }
            }, isOn: isAirplaneModeOn, isEnabled: true)),
            .staticCell(model: SettingsOption(title: "Wi-Fi", icon: UIImage(systemName: "wifi"), iconBackgroundColor: .systemBlue, accessory: .none, detailText: wifi, handler: {
                self.saveWiFi(title: "Wi-Fi", message: "Enter network name:", placeholder: "127.0.0.1")
            }, submenuSections: nil, staticText: nil)),
            .staticCell(model: SettingsOption(title: "Bluetooth", icon: UIImage(named: "Bluetooth"), iconBackgroundColor: .systemBlue, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Bluetooth", message: "Placeholder")
            }, submenuSections: nil, staticText: nil)),
            .staticCell(model: SettingsOption(title: "Cellular", icon: UIImage(systemName: "antenna.radiowaves.left.and.right"), iconBackgroundColor: .systemGreen, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Cellular", message: "Placeholder")
            }, submenuSections: nil, staticText: nil))
        ], footer: ""))
        
        models.append(Section(title: "Random", options: [
            .staticCell(model: SettingsOption(title: "Notifications", icon: UIImage(systemName: "bell.badge.fill"), iconBackgroundColor: .systemRed, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Notifications", message: "Placeholder")
            }, submenuSections: nil, staticText: nil)),
            .staticCell(model: SettingsOption(title: "Sounds & Haptics", icon: UIImage(systemName: "speaker.wave.3.fill"), iconBackgroundColor: .systemPink, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Sounds & Haptics", message: "Placeholder")
            }, submenuSections: nil, staticText: nil)),
            .staticCell(model: SettingsOption(title: "Focus", icon: UIImage(systemName: "moon.fill"), iconBackgroundColor: .systemIndigo, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Focus", message: "Placeholder")
            }, submenuSections: nil, staticText: nil)),
            .staticCell(model: SettingsOption(title: "Screen Time", icon: UIImage(systemName: "hourglass"), iconBackgroundColor: .systemIndigo, accessory: .disclosureIndicator, detailText: nil, handler: {
                self.showAlert(title: "Screen Time", message: "Placeholder")
            }, submenuSections: nil, staticText: nil))
        ], footer: ""))
        
        models.append(Section(title: "About", options: [
            .staticCell(model: SettingsOption(title: "Information", icon: UIImage(systemName: "info.circle"), iconBackgroundColor: .systemGray, accessory: .detailButton, detailText: nil, handler: {
                self.showAlert(title: "Information", message: "Placeholder")
            }, submenuSections: nil, staticText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla venenatis purus eu elit laoreet, id convallis lectus consequat. Pellentesque id mi neque. Duis eget pulvinar eros. Nam ornare hendrerit massa eu sodales. Morbi eget magna at lorem placerat tempus. Duis vel sollicitudin diam, vitae blandit enim. Curabitur eros elit, vehicula at interdum in, elementum lobortis urna. Sed ornare rhoncus risus, a ultrices risus maximus vitae. \n\nNullam aliquet ultrices nulla, eu luctus odio sollicitudin nec. Suspendisse vestibulum bibendum metus sed euismod. Ut elementum consequat ligula, vel lobortis enim viverra ut. Suspendisse commodo, nibh quis posuere auctor, lorem augue malesuada nunc, a dignissim massa ante condimentum risus. Donec condimentum interdum blandit. Curabitur velit orci, feugiat vitae convallis quis, vestibulum eu libero. Phasellus bibendum dignissim eros, sed tempus lorem condimentum vel. Donec eget ullamcorper odio, nec tempor orci. Nunc eget nunc nisl. Maecenas tempor facilisis felis, vitae imperdiet nisl euismod sit amet. \n\nPhasellus at finibus mi, sed accumsan eros. Proin hendrerit risus in nunc feugiat, vitae maximus turpis posuere. Morbi mi elit, sagittis nec placerat et, aliquet vel ante. Aliquam ac urna vel massa laoreet maximus vitae non ipsum. Sed quis augue est. Praesent ac ornare neque. Nullam dictum sem eget tincidunt hendrerit. Sed a neque cursus, finibus mi nec, ullamcorper turpis. Proin elementum, risus vitae posuere varius, urna nisl lobortis lectus, at faucibus leo lectus non velit. Phasellus dignissim suscipit nisi et elementum. Nulla vehicula porttitor turpis ac tristique. Phasellus eleifend mauris ex, sit amet feugiat elit porttitor sed. Donec blandit elementum orci, id consectetur elit vestibulum.")),
            .staticCell(model: SettingsOption(title: "Credits", icon: UIImage(systemName: "person.crop.circle"), iconBackgroundColor: .systemBrown, accessory: .detailButton, detailText: nil, handler: nil, submenuSections: [
                SubmenuSection(header: "Developers", footer: "Tap a name to view their Github.", options: [
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
            ], staticText: nil))
        ], footer: " "))
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
        models[1].options[1] = .staticCell(model: SettingsOption(title: "Wi-Fi", icon: UIImage(systemName: "wifi"), iconBackgroundColor: .systemBlue, accessory: .none, detailText: UserDefaults.standard.string(forKey: "wifi"), handler: {
            self.saveWiFi(title: "Wi-Fi", message: "Enter network name:", placeholder: "127.0.0.1")
        }, submenuSections: nil, staticText: nil))
        tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .fade)
    }
}
