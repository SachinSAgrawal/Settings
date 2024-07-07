# Settings

![demo](demo.gif)

## About
I needed to add a settings page to another app I have been working on, and I could not find anything that was quite what I wanted, so I created this app. If you like this app or found it useful, I would appreciate if you starred it or even shared it with your friends. I also don't expect to work on this too much more, as I am quite satisfied with the end result.

## Acknowledgments
My app is built upon this [tutorial](https://www.youtube.com/watch?v=2FigkAlz1Bg) by iOS Academy to make a Settings-like TableView in Swift. The underlying logic is similar, but I made some improvements so it functions more like a real settings page and data can be passed back and forth. I have kept the UI exactly the same, such that it mirrors the native Settings app because of its familiarity to users.

## Improvements
* There is more customizability for the cells, like the accessory type and whether a switch is enabled.
* Static cells can have submenus with either text or another table view, also fully configurable.
* The handler for switches now runs when the switch is toggled, not when the cell is tapped.
* Static cells can have text inputs that can be saved and displayed instead of an accessory type.
* Whenever a new input is saved, the cell can be reloaded to display the most recent data.
* The settings page can be presented as a popover on top of a main view controller.
* Switch states and inputs can be transferred between controllers using delegates.
* Settings remain set such that a toggle's state persists even when the settings are reopened.
* The most recent commit hash is displayed at the bottom of the settings page.

## Usage
When the app is first launched, there will be a screen with the title "Main App", along with two setting variables. Click on the little gear icon in the bottom right of the app to open up the settings page as a popover. From there, tap on a setting to see what it does. Most of them just show a placeholder alert, but if this was in your app, you could have it do whatever you want. Check out the implementation below for more details. Some of the cells do have proper functionality. For example, when you switch airplane mode off or on, the main app will update accordingly with the boolean value of whether or not it is on. Additionally, you can input a Wi-Fi network, and the text will update in the main app as well. Don't worry, this will not actually enable airplane mode or change the Wi-Fi network on your device; these are just examples to show you how the app could be used. Under the "About" section, clicking on `Information` will bring up a page of lipsum text, as mentioned in the improvements above. Clicking on `Credits` will bring up a submenu that can be fully customized, with many of the same options as the main settings table. Within either of these submenus, a back button will automatically appear. To fully exit the popover, simply swipe down from the top to dismiss it.

## Implementation
Coming soon!

## Installation
1. Clone this repository or download it as a zip folder and uncompress it.
2. Open up the `.xcodeproj` file, which should automatically launch Xcode.
3. You might need to change the signing of the app from the current one.
4. Click the `Run` button near the top left of Xcode to build and install.

#### Prerequisites
Hopefully this goes without saying, but you need Xcode, which is only available on Macs.

#### Notes
You can run this app on the Xcode simulator or connect a physical device. <br>
The device must be either an iPhone or iPad running iOS 17.0 or newer.

## SDKs
* [UIKit](https://developer.apple.com/documentation/uikit/) - Construct and manage a graphical, event-driven user interface for your iOS, iPadOS, or tvOS app.
* [Swift](https://developer.apple.com/swift/) - A powerful and intuitive programming language for all Apple platforms.

## Bugs
If you find any, feel free to open up a new issue or even better, create a pull request fixing it.

#### Known
- [ ] Toggles may reset themselves when scrolling all the way down within the popover.

#### Resolved
- [x] There is no Bluetooth SF symbol. Fixed by using a custom one.

## Contributors
Sachin Agrawal: I'm a self-taught programmer who knows many languages and I'm into app, game, and web development. For more information, check out my website or Github profile. If you would like to contact me, my email is [github@sachin.email](mailto:github@sachin.email).

## License
This package is licensed under the [MIT License](LICENSE.txt).