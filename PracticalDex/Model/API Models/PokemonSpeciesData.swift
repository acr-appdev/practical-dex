//
//  PokemonSpeciesData.swift
//  PracticalDex
//
//  Created by Allan Rosa on 24/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//
// This should follow the same format as the JSON object tree returned by PokeAPI

import Foundation


/**
Stores PokemonSpecies data parsed from JSON responses from PokeAPI
*/
struct PokemonSpeciesData: Decodable {
	let base_happiness: Int
	let capture_rate: Int
	let color: NamedAPIResource
	let egg_groups: [NamedAPIResource]
	let evolution_chain: UnnamedAPIResource
	// let evolves_from_species: EvolvesFromSpeciesData
	let flavor_text_entries: [FlavorTextData]
	//let form_descriptions: [FormDescriptionsData]
	let forms_switchable: Bool
	let gender_rate: Int // in octaves (gender_rate/8 gives the male/female ratio, -1 = genderless)
	let genera: [GeneraData]
	let generation: NamedAPIResource
	let growth_rate: NamedAPIResource
	//let habitat:
	let has_gender_differences: Bool
	let hatch_counter: Int
	let id: Int
	let is_baby: Bool
	let name: String
	let names: [NameData]
	let order: Int
	//let pal_park_encounters: [NamedAPIResource]
	//let pokedex_numbers: [6 items]
	//let shape": {2 items}
	//let varieties": [1 item]
}

struct NameData: Decodable {
	let language: NamedAPIResource
	let name: String
}

struct FlavorTextData: Decodable {
	let flavor_text: String
	let language: NamedAPIResource
	let version: NamedAPIResource
	
}

struct GeneraData: Decodable {
	let genus: String
	let language: NamedAPIResource
}

struct MultiplePokemonData: Decodable {
	let count: Int
	let next: String?
	let previous: String?
	let results: [NamedAPIResource]
}
