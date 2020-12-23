//
//  PokemonObject.swift
//  PracticalDex
//
//  Created by Allan Rosa on 30/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import RealmSwift

final class PokemonObject: Object {
	@objc dynamic var number: Int = 0
	@objc dynamic var name: String = ""
	
	@objc dynamic var primaryType: String = ""
	@objc dynamic var secondaryType: String = ""
	
	@objc dynamic var height: Double = 0 // in Decimeters
	@objc dynamic var weight: Double = 0 // in Grams
	
	@objc dynamic var ability1: String = ""
	@objc dynamic var ability1_isHidden: Bool = false
	@objc dynamic var ability2: String = ""
	@objc dynamic var ability2_isHidden: Bool = false
	@objc dynamic var ability3: String = ""
	@objc dynamic var ability3_isHidden: Bool = true
	
	@objc dynamic var stat_hp:  Int = 0
	@objc dynamic var stat_atk: Int = 0
	@objc dynamic var stat_def: Int = 0
	@objc dynamic var stat_spa: Int = 0
	@objc dynamic var stat_spd: Int = 0
	@objc dynamic var stat_spe: Int = 0
	
	@objc dynamic var sprite_front: String = ""
	@objc dynamic var sprite_back: String = ""
	@objc dynamic var sprite_frontShiny: String = ""
	@objc dynamic var sprite_backShiny: String = ""
	
	let abilities = List<AbilityObject>()
	@objc dynamic var species: SpeciesObject? = nil

	override static func primaryKey() -> String? {
		return "number"
	}
	
	convenience init(pokemon: Pokemon) {
		self.init()
		name = pokemon.name
		number = pokemon.number
		
		primaryType = pokemon.primaryType.description
		secondaryType = pokemon.secondaryType?.description ?? ""
		
		height = pokemon.height.converted(to: .meters).value
		weight = pokemon.weight.converted(to: .kilograms).value
		
		ability1 = pokemon.abilities[1]?.name ?? ""
		ability1_isHidden = ((pokemon.abilities[1]?.isHidden) != nil)
		ability2 = pokemon.abilities[2]?.name ?? ""
		ability2_isHidden = ((pokemon.abilities[2]?.isHidden) != nil)
		ability3 = pokemon.abilities[3]?.name ?? ""
		ability3_isHidden = ((pokemon.abilities[3]?.isHidden) != nil)

		stat_hp  = pokemon.stats.base.hp
		stat_atk = pokemon.stats.base.atk
		stat_def = pokemon.stats.base.def
		stat_spa = pokemon.stats.base.spa
		stat_spd = pokemon.stats.base.spd
		stat_spe = pokemon.stats.base.spe
		
		if let sprite_frontURL = saveImage(pokemon.sprites.male, named: "\(pokemon.name)_front", toFolder: K.App.spritesFolder) {
			sprite_front = sprite_frontURL.lastPathComponent
		}
}
	
	//MARK: - Private Methods
	
}
