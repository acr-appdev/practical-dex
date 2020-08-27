//
//  PokemonObject.swift
//  PracticalDex
//
//  Created by Allan Rosa on 30/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import RealmSwift

final class PokemonObject: Object {
	
	@objc dynamic var identifier = UUID().uuidString
	@objc dynamic var name = ""
	@objc dynamic var number = 0
//	@objc dynamic var sprites: SpriteObject = SpriteObject()
//	@objc dynamic var primaryType: Type = .none
//	@objc dynamic var secondaryType: Type? = nil
//	@objc dynamic var abilities: [AbilityObject] = []
//	@objc dynamic var height = Measurement(value: 0, unit: UnitLength.decimeters)
//	@objc dynamic var weight = Measurement(value: 0, unit: UnitMass.grams)
//	@objc dynamic var stats = StatsObject()
//	@objc dynamic var species: SpeciesObject? = nil

	override static func primaryKey() -> String? {
		return "number"
	}
	
	convenience init(pokemon: Pokemon) {
		self.init()
		identifier = pokemon.identifier
		name = pokemon.name
		number = pokemon.number
//		sprites = SpriteObject(sprites: pokemon.sprites)
//
//		var newAbilities: [AbilityObject] = []
//		pokemon.abilities.forEach({ ability in
//			newAbilities.append(AbilityObject(ability: ability))
//		})
//		height = pokemon.height
//		weight = pokemon.weight
//		stats = StatsObject(stats: pokemon.stats)
//		species = SpeciesObject(withSpecies: pokemon.species ?? Species())
	}
}

//final class SpriteObject: NSObject {
//	@objc dynamic var male: UIImage = #imageLiteral(resourceName: "Missingno.")
//
//	override init() {
//		male = #imageLiteral(resourceName: "Missingno.")
//	}
//	init(sprites: SpriteImages){
//		self.male = sprites.male
//	}
//}
//
//final class AbilityObject: NSObject {
//	@objc dynamic var name: String = ""
//	@objc dynamic var isHidden: Bool = false
//	@objc dynamic var slot: Int = 0
//
//	init(ability: Ability){
//		name = ability.name
//		isHidden = ability.isHidden
//		slot = ability.slot
//	}
//}
//
//final class StatsObject: NSObject {
//	@objc dynamic var base: [String:Int] = [K.Model.hp:0, K.Model.atk:0, K.Model.def:0, K.Model.spa:0, K.Model.spd:0, K.Model.spe:0]
//
//	override init() {
//	}
//
//	init(stats: Stats) {
//		base[K.Model.hp] = stats.base.hp
//		base[K.Model.atk] = stats.base.atk
//		base[K.Model.def] = stats.base.def
//		base[K.Model.spa] = stats.base.spa
//		base[K.Model.spd] = stats.base.spd
//		base[K.Model.spe] = stats.base.spe
//	}
//}

