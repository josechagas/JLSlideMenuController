# JLSlideMenuController

[![CI Status](http://img.shields.io/travis/José Lucas/JLSlideMenuController.svg?style=flat)](https://travis-ci.org/José Lucas/JLSlideMenuController)
[![Version](https://img.shields.io/cocoapods/v/JLSlideMenuController.svg?style=flat)](http://cocoapods.org/pods/JLSlideMenuController)
[![License](https://img.shields.io/cocoapods/l/JLSlideMenuController.svg?style=flat)](http://cocoapods.org/pods/JLSlideMenuController)
[![Platform](https://img.shields.io/cocoapods/p/JLSlideMenuController.svg?style=flat)](http://cocoapods.org/pods/JLSlideMenuController)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
If you want to use this framework you will need at least IOS 8!
## Installation

JLSlideMenuController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JLSlideMenuController"
```

## Initial Configurations

##### *First Step*

Import it on every file that you will use this framework.

```swift
import JLSlideMenuController
```

##### *Second Step*

Remember that every Navigation View Controller that will have this menu should extends `JLSlideNavigationController`.
Example:
    
```swift
class myNavController: JLSlideNavigationController
```
    
##### *Third Step*

Now what you have to go to inspector of your navigation controller and set the properties like the id of your menu vc, name of the storyboard where your menu is.

### *OBS*
    Diferent navigation controllers can have the same instance of the menu vc, for that you just have to choose the same id and storyboard name.



#### *Fourth Step*

Your menu view controller should extends `JLSlideMenuViewController`.
    
    
## Quick Tips
##### *Presenting the menu*
```swift
  showMenu(animated:Bool)
```
#### *Hiding the menu*
```swift
  hideMenu(animated:Bool)
```

#### *Presenting modally another view from the menu*

```swift
presentControllerModally(VCId:String,storyboardName:String,animated:Bool)
```

#### *Presenting another view from the menu*

```swift
showController(VCId:String,storyboardName:String,animated:Bool)
```
    
## *Do not forget to see the example*

    
## Author

José Lucas, joselucas1994@yahoo.com.br

## License

JLSlideMenuController is available under the MIT license. See the LICENSE file for more info.

