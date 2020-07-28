//
//  Pokemon.swift
//  PracticalDex
//
//  Created by Allan Rosa on 11/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

struct Pokemon {
	let name: String
	let number: Int
	var sprites: SpriteImages
	let primaryType: Type
	let secondaryType: Type?
	let abilities: [Ability]
	let height: Measurement<UnitLength>
	let weight: Measurement<UnitMass>
	let flavorText: String
	let stats: Stats
	
	init(withData pkmnData: PokemonData){
		self.name = pkmnData.name.capitalized
		self.number = pkmnData.id
		
		self.primaryType = Type(rawValue: pkmnData.types[0].type.name) ?? Type.none
		//self.primaryType = typeSelector(pkmnData.types[0])
		if pkmnData.types.count > 1 {
			
			self.secondaryType = typeSelector(pkmnData.types[1])
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
		
		self.flavorText = K.Content.Label.loremIpsum
		
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
			// TODO: Probably should fire this code from a DispatchQueue Async and reload the tableview whenever it returns?
			//DispatchQueue.main.async {
			if let imageData = try? Data(contentsOf: imageURL){
				defaultSprite = UIImage(data: imageData)!
			}
		}
		self.sprites = SpriteImages(male: defaultSprite)
	}
}

extension Pokemon {
	
	// Test a custom pokemon
	init(name: String , number: Int, sprites: SpriteImages, primaryType: Type, secondaryType: Type?, abilities: [Ability]){
		self.name = name
		self.number = number
		self.sprites = sprites
		self.primaryType = primaryType
		self.secondaryType = secondaryType
		self.abilities = abilities
		self.height = Measurement<UnitLength>.init(value: Double(Int.random(in: 1...999)), unit: .decimeters)
		self.weight = Measurement<UnitMass>.init(value: Double(Int.random(in: 1...9999)), unit: .grams)
		self.flavorText = "Placeholder flavor text: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. "
		self.stats = Stats(base: BaseStats())
	}
	
	// Create a Placeholder pokemon
	init(){
		self.name = "Missingno"
		self.number = 0
		self.sprites = SpriteImages(male: #imageLiteral(resourceName: "Missingno."))
		self.primaryType = .none
		self.secondaryType = nil
		self.abilities = [Ability(name: "Ability 1", isHidden: false, slot: 1),
						  Ability(name: "Ability 2", isHidden: false, slot: 2),
						  Ability(name: "Hidden Ability", isHidden: true, slot: 3)]
		//self.stats
		self.height = Measurement(value: 69, unit: UnitLength.meters)
		self.weight = Measurement(value: 420, unit: UnitMass.grams)
		self.flavorText = K.Content.Label.loremIpsum
		self.stats = Stats(base: BaseStats())
	}
}


struct Ability {
	let name: String
	let isHidden: Bool
	let slot: Int
}

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

struct Stats {
	let base: BaseStats
	
	
	//	struct EffortValues {
	//	let HP: Int
	//	let Atk: Int
	//	let Def: Int
	//	let SpA: Int
	//	let SpD: Int
	//	let Spe: Int
	//	}
}

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
	
	
	func bst() -> Int {
		return (hp+atk+def+spa+spd+spe)
	}
}


private func typeSelector(_ input: TypeData) -> Type {
	let returnType: Type
	switch input.type.name.lowercased() {
		case "bug" :
			returnType = Type.bug
		case "dark" :
			returnType = Type.dark
		case "dragon" :
			returnType = Type.dragon
		case "electric" :
			returnType = Type.electric
		case "fairy" :
			returnType = Type.fairy
		case "fighting" :
			returnType = Type.fighting
		case "fire" :
			returnType = Type.fire
		case "flying" :
			returnType = Type.flying
		case "ghost" :
			returnType = Type.ghost
		case "grass" :
			returnType = Type.grass
		case "ground" :
			returnType = Type.ground
		case "ice" :
			returnType = Type.ice
		case "normal" :
			returnType = Type.normal
		case "poison" :
			returnType = Type.poison
		case "psychic" :
			returnType = Type.psychic
		case "rock":
			returnType = Type.rock
		case "steel" :
			returnType = Type.steel
		case "water":
			returnType = Type.water
		default:
			returnType = Type.none
	}
	
	return returnType
}
