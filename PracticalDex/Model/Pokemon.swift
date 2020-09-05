//
//  Pokemon.swift
//  PracticalDex
//
//  Created by Allan Rosa on 11/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//
//  This class represents a specific pokemon, such as Marowak or Marowak-Alola
//  Marowak and his Alola form both share the same Species, but are different Pokemon
//  Which results in different stats, abilities, moves, sprites, among other smaller factors such as weight and height

import UIKit
import RealmSwift

/// Represents a specific, particular instance of pokémon, eg.: Marowak vs Marowak-Alola
struct Pokemon {
	let identifier: String // UUID().uuidString
	let name: String
	let number: Int
	var sprites: SpriteImages // Sprites require additional Networking to fetch the images, thus they're declared as variables.
	let primaryType: Type
	let secondaryType: Type?
	let abilities: [Ability]
	let height: Measurement<UnitLength>
	let weight: Measurement<UnitMass>
	let stats: Stats
	var species: Species?
	
	/// Create a placeholder pokemon
	init(){
		self.identifier = UUID().uuidString
		self.name = "Missingno"
		self.number = 0
		self.sprites = SpriteImages(male: #imageLiteral(resourceName: "Missingno."))
		self.primaryType = .none
		self.secondaryType = nil
		self.abilities = [Ability(name: "Ability 1", isHidden: false, slot: 1),
						  Ability(name: "Ability 2", isHidden: false, slot: 2),
						  Ability(name: "Hidden Ability", isHidden: true, slot: 3)]
		self.height = Measurement(value: 69, unit: UnitLength.meters)
		self.weight = Measurement(value: 420, unit: UnitMass.grams)
		self.stats = Stats(base: BaseStats())
		self.species = nil
	}
	
	/// Create a pokemon using PokeAPI data
	init(withData pkmnData: PokemonData){
		self.identifier = UUID().uuidString
		self.name = pkmnData.name.capitalized
		self.number = pkmnData.id
		
		self.primaryType = Type(rawValue: pkmnData.types[0].type.name) ?? Type.none
		//self.primaryType = typeSelector(pkmnData.types[0])
		if pkmnData.types.count > 1 {
			self.secondaryType = Type(rawValue: pkmnData.types[1].type.name.lowercased())
		} else {
			self.secondaryType = nil
		}
		
		var abilitySet: [Ability] = []
		pkmnData.abilities.forEach({ability in
			let abilityName = ability.ability.name.capitalized.replacingOccurrences(of: "-", with: " ")
			abilitySet.append(Ability(name: abilityName, isHidden: ability.is_hidden, slot: ability.slot))
		})
		self.abilities = abilitySet
		
		let weightInGrams = Double(pkmnData.weight)*100 // Alternatively, create an extension on UnitMass to implement .hectograms
		self.weight = Measurement(value: weightInGrams, unit: UnitMass.grams)
		self.height = Measurement(value: Double(pkmnData.height), unit: UnitLength.decimeters)
		
		let hp_string = "hp"
		let atk_string = "attack"
		let def_string = "defense"
		let spa_string = "special-attack"
		let spd_string = "special-defense"
		let spe_string = "speed"
		var baseStats = [hp_string : 0, atk_string : 0, def_string : 0, spa_string : 0, spd_string : 0, spe_string : 0]
		
		pkmnData.stats.forEach({ stat in
			baseStats[stat.stat.name.lowercased()] = stat.base_stat
		})
		let bs = BaseStats(hp: baseStats[hp_string]!, atk: baseStats[atk_string]!, def: baseStats[def_string]!, spa: baseStats[spa_string]!, spd: baseStats[spd_string]!, spe: baseStats[spe_string]!)
		self.stats = Stats(base: bs)
		
		// This should be the last part initialized because we have to retrieve the data from another url
		var defaultSprite = #imageLiteral(resourceName: "Missingno.")
		self.sprites = SpriteImages(male: defaultSprite) // Assign a placeholder
		if let imageURL = URL(string: pkmnData.sprites.front_default){
			//TODO: Probably should fire this code from a DispatchQueue Async and either reload the tableview whenever it returns or freeze the background
			if let imageData = try? Data(contentsOf: imageURL){
				defaultSprite = UIImage(data: imageData)!
			}
		}
		self.sprites = SpriteImages(male: defaultSprite)
		self.species = nil
	}
}

// MARK: Realm Object Extension
extension Pokemon: Persistable {

	public init(managedObject: PokemonObject) {
		identifier = managedObject.identifier
		name = managedObject.name
		number = managedObject.number
		
		height = Measurement(value: managedObject.height, unit: UnitLength.meters)
		weight = Measurement(value: managedObject.weight, unit: UnitMass.kilograms)
		
		primaryType = getType(from: managedObject.primaryType)
		let type = getType(from: managedObject.secondaryType)
		if type != .none { secondaryType = type }
		else { secondaryType = nil }

		let baseStats = BaseStats(hp: managedObject.stat_hp,
								 atk: managedObject.stat_atk,
								 def: managedObject.stat_def,
								 spa: managedObject.stat_spa,
								 spd: managedObject.stat_spd,
								 spe: managedObject.stat_spe)
		stats = Stats(base: baseStats)
		
		let imageURL = getDocumentsDirectory().appendingPathComponent(K.App.spritesFolder).appendingPathComponent(managedObject.sprite_front)
		if let maleSprite = UIImage(contentsOfFile: imageURL.path){
			sprites = SpriteImages(male: maleSprite)
		} else {
			sprites = SpriteImages(male: #imageLiteral(resourceName: "Missingno."))
		}
		
		self.abilities = [Ability(name: "Ability 1", isHidden: false, slot: 1),
						  Ability(name: "Ability 2", isHidden: false, slot: 2),
						  Ability(name: "Hidden Ability", isHidden: true, slot: 3)]
		self.species = nil
		
	}

	/// Returns the Realm Object implementation for the class.
	func managedObject() -> PokemonObject {
		let pokemonObject = PokemonObject(pokemon: self)
		return pokemonObject
	}
}

// MARK: Extra Structs Definition

/// Provides pokémon sprites
struct SpriteImages {
	let male: UIImage
	// let female: UIImage
	// let shinyMale: UIImage
	// let shinyFemale: UIImage
	// let male_back: UIImage
	// let female_back: UIImage
	// let shinyMale_back: UIImage
	// let shinyFemale_back: UIImage
	
}

/// Provides pokémon stat data, related to calculating damage (calc function)
struct Stats {
	let base: BaseStats
	// let evs: EffortValues
	// let ivs: IndividualValues
	
	init(base: BaseStats = BaseStats.init()) {
		self.base = base
	}
}

/// Stores the base stats for a given pokémon, ranging from
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

