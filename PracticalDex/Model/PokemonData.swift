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
	// let abilities: [Ability]
	// let base_experience: Int
	// let forms: [Form]
	// let game_indices
	// let height: Int
	let id: Int // number
	// let is_default: Boolean
	// let location_area_encounters:
	// let moves: [Move]
	let name: String
	// let order: Int
	// let species: Specie
	// let sprites: Sprites
	// let stats: [Stats]
	// let types: [Type]
	// let weight: Int
	
	
}

private struct Stats: Decodable {
	let base_stat: Int
	let effort: Int
	let stat: Stat
}

private struct Stat: Decodable {
	let name: String
	let url: String
}
