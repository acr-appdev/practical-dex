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
	struct App {
		struct Model {
			
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


// Enums below map a case to a string taken from pokeAPI

enum Type: String {
	// String value taken from https://pokeapi.co/api/v2/type
	case normal = "normal"
	case fire = "fire"
	case water = "water"
	case electric = "electric"
	case grass = "grass"
	case ice = "ice"
	case fighting = "fighting"
	case poison = "poison"
	case ground = "ground"
	case flying = "flying"
	case psychic = "psychic"
	case bug = "bug"
	case rock = "rock"
	case ghost = "ghost"
	case dragon = "dragon"
	case dark = "dark"
	case steel = "steel"
	case fairy = "fairy"
	case none = "unknown"
}

enum EggGroup: String {
	// String value taken from https://pokeapi.co/api/v2/egg-group/
	case monster = "monster"
	case water1 = "water1"
	case water2 = "water2"
	case water3 = "water3"
	case humanlike = "humanshape"
	case bug = "bug"
	case mineral = "mineral"
	case flying = "flying"
	case amorphous = "indeterminate"
	case field = "field"
	case fairy = "fairy"
	case ditto = "ditto"
	case grass = "plant"
	case dragon = "dragon"
	case undiscovered = "no-eggs" // Named No Eggs Discovered on bulbapedia
}

enum GameVersion: String {
	// String value taken from https://pokeapi.co/api/v2/version?offset=0&limit=100
	case red = "red"
	case blue = "blue"
	case yellow = "yellow"
	case gold = "gold"
	case silver = "silver"
	case crystal = "crystal"
	case ruby = "ruby"
	case sapphire = "sapphire"
	case emerald = "emerald"
	case firered = "firered"
	case leafgreen = "leafgreen"
	case diamond = "diamond"
	case pearl = "pearl"
	case platinum = "platinum"
	case black = "black"
	case white = "white"
	case xd = "xd"
	case colosseum = "colosseum"
	case black2 = "black-2"
	case white2 = "white-2"
	case x = "x"
	case y = "y"
	case omegaruby = "omega-ruby"
	case alphasapphire = "alpha-sapphire"
	case sun = "sun"
	case moon = "moon"
	case ultrasun = "ultra-sun"
	case ultramoon = "ultra-moon"
	case sword = "sword"
	case shield = "shield"
}

enum Language: String {
	// String value taken from https://pokeapi.co/api/v2/language
	case ja_hrkt = "ja-hrkt" // Japanese Hiragana/Katakana
	case romaji = "roomaji"
	case zh_hant = "zh-hant" // Chinese Traditional
	case fr = "fr"
	case de = "de"
	case es = "es"
	case it = "it"
	case en = "en"
	case cs = "cs"
	case ja = "ja"
	case zh_hans = "zh-hans" // Chinese Simplified
	case pt_BR = "ptbr"
}

enum Generation: String {
	// String value taken from https://pokeapi.co/api/v2/version
	case i = "generation-i"
	case ii = "generation-ii"
	case iii = "generation-iii"
	case iv = "generation-iv"
	case v = "generation-v"
	case vi = "generation-vi"
	case vii = "generation-vii"
	case viii = "generation-viii"
}
