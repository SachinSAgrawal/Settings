//
//  ViewController.swift
//  Settings
//
//  Created by Sachin Agrawal on 6/27/24.
//

import UIKit

class MainViewController: UIViewController, SettingsDelegate {
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var wifiLabel: UILabel!
    @IBOutlet weak var airplaneMode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Read the user defaults for the WiFi if present
        let savedWifi = UserDefaults.standard.string(forKey: "wifi")
        wifiLabel.text = "WiFi: \(savedWifi ?? "127.0.0.1")"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Check if the correct segue is being performed
        if segue.identifier == "toSettings" {
            if let navigationController = segue.destination as? UINavigationController {
                if let settingsVC = navigationController.topViewController as? SettingsViewController {
                    // Set the delegate of the settings view controller
                    settingsVC.delegate = self
                    
                    // Send the most updated values to settings so the toggle states are accurate
                    settingsVC.isAirplaneModeOn = (airplaneMode.text == "Airplane Mode: true")
                }
            }
        }
    }
    
    @IBAction func settingsPressed(_ sender: UIButton) {
        // Present the settings page as a popover
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    func updatedWifi(name: String) {
        // Update label will recieved valued
        wifiLabel.text = "WiFi: \(name)"
    }
    
    func airplaneMode(value: Bool) {
        // Update label will recieved valued
        airplaneMode.text = "Airplane Mode: \(value)"
    }
}
