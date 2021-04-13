//
// Constants.swift
// PracticalDex
//
// Created by Allan Rosa on 11/07/20.
// Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

struct K {
	
	struct Design {
		struct Color {
			static let menuLightBlue = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
			static let red = UIColor(named: "theme-red") ?? #colorLiteral(red: 0.900775373, green: 0.2945650816, blue: 0.2367742062, alpha: 1)
			static let blue = UIColor(named: "theme-blue") ?? #colorLiteral(red: 0.1739603281, green: 0.2390800714, blue: 0.3204770088, alpha: 1)
			static let darkBlue = UIColor(named: "theme-darkblue") ?? #colorLiteral(red: 0.1028242931, green: 0.1450264752, blue: 0.1898280084, alpha: 1)
			static let white = UIColor(named: "theme-white") ?? #colorLiteral(red: 0.9217720628, green: 0.9412187338, blue: 0.9451423287, alpha: 1)
		}
		struct Image {
			static let pkmnSpritePlaceholder = "placeholder-missingno"
			static let iconCogwheel = "icon-cogwheel"
			static let iconPokedex = "icon-pokedex"
		}
	}
	
	struct Model {
		static let hp = "hp"
		static let atk = "atk"
		static let def = "def"
		static let spa = "spa"
		static let spd = "spd"
		static let spe = "spe"
	}
	
	struct App {
		static let spritesFolder = "PokedexSprites"
		static let bgmList = ["Analog-Nostalgia", "Monster-Street-Fighters", "The-8-bit-Princess", "Whimsical-Popsicle", "Racing-Menu"]
		static let wallpaperList = ["box-backyard", "box-forest", "box-heartgold", "box-kimonogirl", "box-monochrome", "box-musical", "box-pikapika", "box-pokeathlon", "box-pokecenter", "box-ribbon", "box-savannah", "box-simple", "box-sky", "box-soulsilver", "box-volcano", "box-zigzagoon"]
		
		// rework into extension [https://cocoacasts.com/ud-12-benefits-of-creating-an-extension-for-user-defaults]
		struct Defaults {
			static let hasLaunchedBefore = "hasLaunchedBefore"
			static let databaseIsPopulated = "databaseIsPopulated"
			static let appVolume = "appVolume"
			static let selectedWallpaper = "selectedWallpaper"
			static let selectedBGM = "selectedBGM"
			static let selectedBGMIndex = "selectedBGMIndex"
			static let selectedWallpaperIndex = "selectedWallpaperIndex"
			static let selectedLanguage = "selectedLanguage"
		}
		struct View {
			struct Segue {
				static let detailView = "goToDetailView"
				static let infoPageView = "goToInfoPageView"
			}
			struct Cell {
				static let pokedex = "PokedexCell"
				static let settings = "SettingsCell"
			}
			static let headerSearchBar = "HeaderSearchBar"
			static let infoPageVC = "InfoPageViewController"
			static let aboutVC = "AboutVC"
			static let evolutionVC = "EvolutionVC"
			static let movesVC = "MovesVC"
			static let statsVC = "StatsVC"
		}
		
	}
	
	struct Content {
		struct Label {
			static let loremIpsum = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."
			static let dummyLabelLong = "This is a dummy label"
			static let dummyLabelShort = "DummyLabel"
		}
		
	}
}
