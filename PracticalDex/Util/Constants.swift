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
			struct Primary {
			}
			struct Secondary {
			}
			struct Grayscale {
			}
			struct Alpha {
				
			}
		}
		struct Icon {
			
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
		
		struct UserDefaults {
			static let databaseIsPopulated = "databaseIsPopulated"
		}
		struct View {
			struct Segue {
				static let detailView = "goToDetailView"
				static let infoPageView = "goToInfoPageView"
			}
			struct Cell {
				static let pokedex = "PokedexCell"
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
		}
	}
}
