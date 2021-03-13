//
//  Stats.swift
//  PracticalDex
//
//  Created by Allan Rosa on 08/12/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import Foundation

/// Provides pokémon stat data, related to calculating damage (calc function)
struct Stats {
	let base: BaseStats
	// let evs: EffortValues
	// let ivs: IndividualValues
	
	init(base: BaseStats = BaseStats.init()) {
		self.base = base
	}
}

/// Stores the base stats for a given pokémon
struct BaseStats {
	let hp: Int
	let atk: Int
	let def: Int
	let spa: Int
	let spd: Int
	let spe: Int
	
	init(hp: Int = Int.random(in: 1...255), atk: Int = Int.random(in: 1...255), def: Int = Int.random(in: 1...255), spa: Int = Int.random(in: 1...255), spd: Int = Int.random(in: 1...255), spe: Int = Int.random(in: 1...255)){
		
		self.hp = hp
		self.atk = atk
		self.def = def
		self.spa = spa
		self.spd = spd
		self.spe = spe
	}
	
	/// Returns the Base Stat Total for this pokémon
	func bst() -> Int {
		return (hp+atk+def+spa+spd+spe)
	}
}
