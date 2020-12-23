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
	let name: String
	let number: Int
	var sprites: SpriteImages // Sprites require additional Networking to fetch the images, thus they're declared as variables.
	let primaryType: Type
	let secondaryType: Type?
	var abilities: [Int : Ability]
	let height: Measurement<UnitLength>
	let weight: Measurement<UnitMass>
	let stats: Stats
	var species: Species?
	
	/// Create a placeholder pokemon
	init(){
		self.name = "Missingno"
		self.number = 0
		let img = UIImage(named: "placeholder-missingno")
		self.sprites = SpriteImages(male: img!)
		self.primaryType = .none
		self.secondaryType = nil
		let ability1 = Ability(name: "Ability 1", isHidden: false, slot: 1)
		let ability2 = Ability(name: "Ability 2", isHidden: false, slot: 2)
		let ability3 = Ability(name: "Hidden Ability", isHidden: true, slot: 3)
		self.abilities = [:]
		self.abilities[ability1.slot] = ability1
		self.abilities[ability2.slot] = ability2
		self.abilities[ability3.slot] = ability3
		self.height = Measurement(value: 69, unit: UnitLength.meters)
		self.weight = Measurement(value: 420, unit: UnitMass.grams)
		self.stats = Stats(base: BaseStats())
		self.species = nil
	}
	
	/// Create a pokemon using PokeAPI data
	init(withData pkmnData: PokemonData){
		self.name = pkmnData.name.capitalized
		self.number = pkmnData.id
		
		self.primaryType = Type(pkmnData.types[0].type.name)
		
		if pkmnData.types.count > 1 {
			self.secondaryType = Type(pkmnData.types[1].type.name)
		} else {
			self.secondaryType = nil
		}
		
		let weightInGrams = Double(pkmnData.weight)*100 // Alternatively, create an extension on UnitMass to implement .hectograms (PokeAPI uses Hectograms)
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
		var defaultSprite = UIImage(named: K.Design.Image.pkmnSpritePlaceholder)!
		self.sprites = SpriteImages(male: defaultSprite) // Assign a placeholder
		
		if let imageURL = URL(string: pkmnData.sprites.front_default){
			
			if let imageData = try? Data(contentsOf: imageURL){
				defaultSprite = UIImage(data: imageData)!
			}
		}
		self.sprites = SpriteImages(male: defaultSprite)
		
		self.abilities = [:]
		pkmnData.abilities.forEach({ abilityData in
			let abilityName = abilityData.ability.name.capitalized.replacingOccurrences(of: "-", with: " ")
			let newAbility = Ability(name: abilityName, isHidden: abilityData.is_hidden, slot: abilityData.slot)
			
			self.abilities[newAbility.slot] = newAbility
		})
		
		self.species = nil
	}
}

//MARK: -- PROTOCOLS --
extension Pokemon: Hashable {
	static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
		return lhs.number == rhs.number
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(self.number)
	}
}


// MARK: Realm Object Extension
extension Pokemon: Persistable {
	
	public init(managedObject: PokemonObject) {
		name = managedObject.name
		number = managedObject.number
		
		height = Measurement(value: managedObject.height, unit: UnitLength.meters)
		weight = Measurement(value: managedObject.weight, unit: UnitMass.kilograms)
		
		primaryType = Type(managedObject.primaryType)
		let type = Type(managedObject.secondaryType)
		secondaryType = type != .none ? type : nil
		
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
		
		// TODO: - Rework Abilities
		abilities = [:]
		abilities[1] = Ability(name: managedObject.ability1, isHidden: managedObject.ability1_isHidden, slot: 1)
		if managedObject.ability2 != "" {
			abilities[2] = Ability(name: managedObject.ability2, isHidden: managedObject.ability2_isHidden, slot: 2)
		}
		if managedObject.ability3 != "" {
			abilities[2] = Ability(name: managedObject.ability3, isHidden: managedObject.ability3_isHidden, slot: 3)
		}
		
		let matchNumberPredicate = NSPredicate(format: "number == \(number)")
		self.species = nil
		DataService.shared.retrieve(Species.self, predicate: matchNumberPredicate, completion: { (retrievedList) in
			self.species = retrievedList.first
		})
		
	}
	
	/// Returns the Realm Object implementation for the class.
	func managedObject() -> PokemonObject {
		let pokemonObject = PokemonObject(pokemon: self)
		return pokemonObject
	}
}
