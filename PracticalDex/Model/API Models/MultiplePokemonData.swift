//
//  MultiplePokemonData.swift
//  PracticalDex
//
//  Created by Allan Rosa on 15/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//
// This should follow the same format as the JSON object tree returned by PokeAPI

import Foundation

struct MultiplePokemonData: Decodable {
	let count: Int
	let next: String?
	let previous: String?
	let results: [NamedAPIResource]
}
