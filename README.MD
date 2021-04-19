

# Practical Dex

<p align="center">
  <a href="https://github.com/acr-appdev/practical-dex">
	<img src="practdex-icon.svg" alt="Logo" width="80" height="80">
  </a>
  <p align="center">

	This is my first personal iOS development project, the project development primary goals are to solidify both knowledge in the Swift programming language as well as the human interface design guidelines provided by Apple.
	
	Some important project decisons are as follows:
		- Use of the MVC pattern to keep code organized.
		- Restricted use of external libraries: This should make me think for myself when facing simple but common issues which are solved by creating simple extensions, while thinking of ways to generalize code in order to improve its reusability.
			- RealmSwift was used, despite the self-imposed restriction, to test the implementation details of a decoupled data-layer. This means that it should be possible to change the data persistence implementation to Core Data, for example, without having to make big changes in the Business Logic/View Layers.
			- The use of RealmSwift also serves as a good practice to keep code working with the ever evolving external libraries. CocoaPods is used to keep RealmSwift updated.
		- Develop a Settings page that can be reused for any app, which can be expanded with ease if needed. It includes features such as customizable background music, in order to explore possible features unrelated to the main app objective.
<p align="center">
<img src= "PractDexPreview.mp4" width="300" >
</p>


## Features

- [x] Pokédex details include pokédex entries, gender ratio, egg group, weight and height
- [x] Useful battle related data such as base stats, abilities and typing
- [x] Customizable background, featuring artwork from original games boxes wallpapers
- [x] Choose a background music and adjust its in-app volume from a variety of cool preselected songs

## Requirements

- iOS 13.0+
- Swift 5
- Xcode 11

## Installation

1. Clone the repository:

    ```bash
   git clone https://github.com/acr-appdev/practical-dex.git
   ```

2. Install pod dependencies:

   ```bash
   cd PracticalDex
   pod install
   ```

3. Open the workspace in XCode:

   ```````bash
   open "practical-dex.xcworkspace"
   ```````

## Planned Features

- [ ] Expand displayed Pokémon Species details, such as required steps to hatch egg, EV yield and many other info
- [ ] Display the Species evolution chain
- [ ] Add Abilities and Moves libraries to check detailed info about them

## Contribute

Project is closed for contributions but suggestions are welcome.

## Meta

Allan C. Rosa – [@allanrosa_dev](https://twitter.com/allanrosa_dev – allan.rosa.dev@gmail.com

[https://github.com/acr-appdev/practical-dex](https://github.com/acr-appdev/)

[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/