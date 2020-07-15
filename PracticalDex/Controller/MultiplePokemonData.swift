//
//  MultiplePokemonData.swift
//  PracticalDex
//
//  Created by Allan Rosa on 15/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import Foundation

struct MultiplePokemonData: Decodable {
	let count: Int
	let next: String?
	let previous: String?
	let results: [PokemonResource]
}

struct PokemonResource: Decodable {
	let name: String
	let url: String
}
