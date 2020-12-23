//
//  PokemonEnums.swift
//  PracticalDex
//
//  Created by Allan Rosa on 18/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

// MARK: - Enum Type
/// String value taken from https://pokeapi.co/api/v2/type
enum Type: Int, CaseIterable, CustomStringConvertible {
	case normal
	case fire
	case water
	case electric
	case grass
	case ice
	case fighting
	case poison
	case ground
	case flying
	case psychic
	case bug
	case rock
	case ghost
	case dragon
	case dark
	case steel
	case fairy
	case none // Renamed to none
	case shadow // Probably unused
	
	init(_ value: String){
		switch value.lowercased() {
			case "normal": self = .normal
			case "fire": self = .fire
			case "water": self = .water
			case "electric": self = .electric
			case "grass": self = .grass
			case "ice": self = .ice
			case "fighting": self = .fighting
			case "poison": self = .poison
			case "ground": self = .ground
			case "flying": self = .flying
			case "psychic": self = .psychic
			case "bug": self = .bug
			case "rock": self = .rock
			case "ghost": self = .ghost
			case "dragon": self = .dragon
			case "dark": self = .dark
			case "steel": self = .steel
			case "fairy": self = .fairy
			case "shadow": self = .shadow
			default: self = .none
		}
	}
	
	var description: String {
		switch self {
			case .normal: return "Normal"
			case .fire: return "Fire"
			case .water: return "Water"
			case .electric: return "Electric"
			case .grass: return "Grass"
			case .ice: return "Ice"
			case .fighting: return "Fighting"
			case .poison: return "Poison"
			case .ground: return "Ground"
			case .flying: return "Flying"
			case .psychic: return "Psychic"
			case .bug: return "Bug"
			case .rock: return "Rock"
			case .ghost: return "Ghost"
			case .dragon: return "Dragon"
			case .dark: return "Dark"
			case .steel: return "Steel"
			case .fairy: return "Fairy"
			case .none: return "Unknown" // Renamed to none
			case .shadow: return "Shadow" // Probably unused
		}
	}
}

// MARK: - Enum EggGroup
/// String value taken from https://pokeapi.co/api/v2/egg-group/
enum EggGroup: String {
	case monster
	case water1
	case water2
	case water3
	case bug
	case mineral
	case flying
	case field
	case fairy
	case ditto
	case dragon
	case amorphous = "indeterminate" // Renamed to conform to bulbapedia
	case grass = "plant" // Renamed to conform to bulbapedia
	case humanlike = "humanshape" // Renamed to conform to bulbapedia
	case undiscovered = "no-eggs" // Renamed to conform to bulbapedia
}

// MARK: - Enum GameVersion
/// String value taken from https://pokeapi.co/api/v2/version?offset=0&limit=100
enum GameVersion: String {
	case red
	case blue
	case yellow
	case gold
	case silver
	case crystal
	case ruby
	case sapphire
	case emerald
	case firered
	case leafgreen
	case diamond
	case pearl
	case platinum
	case black
	case white
	case xd
	case colosseum
	case black2 = "black-2"
	case white2 = "white-2"
	case x
	case y
	case omegaruby = "omega-ruby"
	case alphasapphire = "alpha-sapphire"
	case sun
	case moon
	case ultrasun = "ultra-sun"
	case ultramoon = "ultra-moon"
	case sword
	case shield
}

// MARK: - Enum Language
/// String value taken from https://pokeapi.co/api/v2/language
enum Language: String {
	case ja_hrkt = "ja-Hrkt" // Japanese Hiragana/Katakana
	case romaji = "roomaji"
	case zh_hant = "zh-Hant" // Chinese Traditional
	case fr
	case de
	case es
	case it
	case en
	case cs
	case ja
	case zh_hans = "zh-Hans" // Chinese Simplified
	case pt_BR = "ptbr"
}

// MARK: - Enum Generation
/// String value taken from https://pokeapi.co/api/v2/version
enum Generation: String {
	case i = "generation-i"
	case ii = "generation-ii"
	case iii = "generation-iii"
	case iv = "generation-iv"
	case v = "generation-v"
	case vi = "generation-vi"
	case vii = "generation-vii"
	case viii = "generation-viii"
}

// MARK: - Utility Methods
func colorSelector(for type: Type) -> UIColor{
	switch type {
		case .bug:
			return #colorLiteral(red: 0.6589999795, green: 0.7220000029, blue: 0.125, alpha: 1)
		case .dark:
			return #colorLiteral(red: 0.4390000105, green: 0.3449999988, blue: 0.2820000052, alpha: 1)
		case .dragon:
			return #colorLiteral(red: 0.4399999976, green: 0.2199999988, blue: 0.9739999771, alpha: 1)
		case .electric:
			return #colorLiteral(red: 0.9739999771, green: 0.8119999766, blue: 0.1899999976, alpha: 1)
		case .fairy:
			return #colorLiteral(red: 0.9330000281, green: 0.6000000238, blue: 0.6750000119, alpha: 1)
		case .fighting:
			return #colorLiteral(red: 0.753000021, green: 0.1879999936, blue: 0.1570000052, alpha: 1)
		case .fire:
			return #colorLiteral(red: 0.9409999847, green: 0.5019999743, blue: 0.1920000017, alpha: 1)
		case .flying:
			return #colorLiteral(red: 0.6589999795, green: 0.5640000105, blue: 0.9409999847, alpha: 1)
		case .ghost:
			return #colorLiteral(red: 0.4390000105, green: 0.3449999988, blue: 0.5960000157, alpha: 1)
		case .grass:
			return #colorLiteral(red: 0.4709999859, green: 0.7839999795, blue: 0.3140000105, alpha: 1)
		case .ground:
			return #colorLiteral(red: 0.878000021, green: 0.753000021, blue: 0.4120000005, alpha: 1)
		case .ice:
			return #colorLiteral(red: 0.5970000029, green: 0.8470000029, blue: 0.8470000029, alpha: 1)
		case .normal:
			return #colorLiteral(red: 0.6579999924, green: 0.6589999795, blue: 0.4690000117, alpha: 1)
		case .poison:
			return #colorLiteral(red: 0.625, green: 0.25, blue: 0.6259999871, alpha: 1)
		case .psychic:
			return #colorLiteral(red: 0.9750000238, green: 0.3449999988, blue: 0.5320000052, alpha: 1)
		case .rock:
			return #colorLiteral(red: 0.7200000286, green: 0.628000021, blue: 0.2210000008, alpha: 1)
		case .steel:
			return #colorLiteral(red: 0.7220000029, green: 0.7210000157, blue: 0.8149999976, alpha: 1)
		case .water:
			return #colorLiteral(red: 0.4050000012, green: 0.5640000105, blue: 0.9409999847, alpha: 1)
		default:
			return #colorLiteral(red: 0.4120000005, green: 0.628000021, blue: 0.5659999847, alpha: 1)
	}
}

// MARK: - StatBar Color Selector
//TODO: Implement a gradient return
func colorSelector(for stat: Int) -> UIColor {
	if 0...60 ~= stat { return .red }
	if 61...85 ~= stat { return .orange }
	if 86...100 ~= stat { return .yellow }
	if 100...999 ~= stat { return .green }
	else { return .gray }
}
