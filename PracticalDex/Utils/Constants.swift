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
