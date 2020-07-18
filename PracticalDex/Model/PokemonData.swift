//
//  PokemonData.swift
//  PracticalDex
//
//  Created by Allan Rosa on 11/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//
// This should follow the same format as the JSON object tree returned by PokeAPI

import Foundation

struct PokemonData: Decodable {
	let abilities: [AbilityAttribute]
	// let base_experience: Int
	// let forms: [Form]
	// let game_indices
	let height: Int
	let id: Int // number
	// let is_default: Boolean
	// let location_area_encounters:
	// let moves: [Move]
	let name: String
	// let order: Int
	//let species: SpeciesData
	let sprites: Sprites
	// let stats: [Stats]
	let types: [TypeData]
	let weight: Int
}

struct AbilityAttribute: Decodable {
	let ability: AbilityData
	
	let is_hidden: Bool
	let slot: Int
}

struct AbilityData: Decodable {
	let name: String
	//let resourceURL: String
}

struct TypeData: Decodable {
	let slot: Int
	let type: TypeAttribute
}
struct TypeAttribute: Decodable {
	let name: String
	// let resourceURL: String // not used
}

struct SpeciesData: Decodable {
	let name: String
	let resourceURL: String
}

//private struct Stats: Decodable {
//	let base_stat: Int
//	let effort: Int
//	let stat: Stat
//}
//
//private struct Stat: Decodable {
//	let name: String
//	let url: String
//}

struct Sprites: Decodable {
//	let back_default: String
//	let back_female: String?
//	let back_shiny: String
//	let back_shiny_female: String?
	let front_default: String
//	let front_female: String?
//	let front_shiny: String
//	let front_shiny_female: String?
}
