//
//  PokemonData.swift
//  PracticalDex
//
//  Created by Allan Rosa on 11/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//
// This should follow the same format as the JSON object tree returned by PokeAPI

import Foundation

/**
Stores Pokémon data from parsed JSON responses from PokeAPI
*/
struct PokemonData: Decodable {
	let abilities: [AbilityData]
	// let base_experience: Int
	// let forms: [Form]
	// let game_indices
	/// Measured in decimeters (1dm = 0.1m)
	let height: Int
	let id: Int // number
	// let is_default: Boolean
	// let location_area_encounters:
	// let moves: [Move]
	let name: String
	// let order: Int
	let species: NamedAPIResource
	let sprites: Sprites
	let stats: [StatsData]
	let types: [TypeData]
	/// Measured in hectograms (1hg = 100g = 0.1kg)
	let weight: Int
}

struct AbilityData: Decodable {
	let ability: NamedAPIResource
	let is_hidden: Bool
	let slot: Int
}

struct NamedAPIResource: Decodable {
	let name: String
	let url: String
}

struct UnnamedAPIResource: Decodable {
	let url: String
}

struct TypeData: Decodable {
	let slot: Int
	let type: NamedAPIResource
}

struct StatsData: Decodable {
	let base_stat: Int
	let effort: Int
	let stat: NamedAPIResource
}

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
