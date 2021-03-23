[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)

# Practical Dex
<p align="center">
  <a href="https://github.com/alexanderritik/Best-README-Template">
	<img src="logo.jpeg" alt="Logo" width="80" height="80">
  </a>
  <p align="center">
	This is my first personal iOS development project, the project development primary goals are to improve programming skills and solidify both knowledge in the Swift programming language as well as the human interface design guidelines provided by Apple.
	Some important project decisons are as follows:
	- Use of the MVC pattern to keep code organized. MVVC pattern might me used in the future when the project grows. 
	- Restricted use of external libraries: This should make me think for myself when facing simple but common issues which are solved by creating simple extensions, while thinking of ways to generalize code in order to improve its reusability.
		- RealmSwift was used, despite the self-imposed restriction, to test a decoupled data-layer. This means that it should be possible to change the data persistence implementation to Core Data, for example, without having to make big changes in the Business Logic/View Layers.
		- The use of RealmSwift also serves as a good practice to keep code working with the ever evolving external libraries. CocoaPods is used to keep RealmSwift updated.
	- Develop a Settings page that can be reused for any app, which can be expanded with ease if needed. It includes sugar-coating features such as customizable background music to explore possible features unrelated to the main app objective.
<p></p>



<p align="row">
<img src= "https://media.giphy.com/media/HYOlBKJBqgAfe/giphy.gif" width="400" >
</p>


## Features

- [x] Pokédex details include pokédex entries, gender ratio, egg group, weight and height
- [x] Useful battle related data such as base stats, abilities and typing
- [x] Customizable background, featuring artwork from original games boxes wallpapers
- [x] Choose a background music and adjust its in-app volume from a variety of cool preselected songs

## Requirements

- iOS 13.0+
- Xcode 11

## Installation

#### Git
You can use [CocoaPods](http://cocoapods.org/) to install `YourLibrary` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!
pod 'YourLibrary'
```

To get the full benefits import `YourLibrary` wherever you import UIKit

``` swift
import UIKit
import YourLibrary
```

```
github "yourUsername/yourlibrary"
```
#### Manually
1. Download and drop ```YourLibrary.swift``` in your project.  
2. Congratulations!  


## Contribute

All suggestions are welcome,  

## Meta

Allan C. Rosa – [@acr_appdev](https://twitter.com/acr_appdev) – acr.appdeveloper@gmail.com



Distributed under the XYZ license. See ``LICENSE`` for more information.

[https://github.com/yourname/github-link](https://github.com/dbader/)

[swift-image]:https://img.shields.io/badge/swift-3.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
