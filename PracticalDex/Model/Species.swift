//
//  Species.swift
//  PracticalDex
//
//  Created by Allan Rosa on 26/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//
//  This class represents a whole pokemon species, such as Wormadam, which includes all forms of Wormadam

import UIKit

/// Represents a pokemon species, which represents all pokémon that share a given name. eg: Wormadam, which includes Wormadam-Sandy, Wormadam-Trash, Wormadam-Planty. 
struct Species {
	let identifier: String // UUID().uuidString
	let baseHappiness: Int
	let captureRate: Int
	let color: UIColor
	let eggGroups: [EggGroup]
	let flavorTextEntries: [FlavorTextEntry]
	let genderRate: Double? // percentage value, nil = genderless
	let genera: [Genus]
	let generation: Generation
	let growthRate: String // https://pokeapi.co/api/v2/growth-rate/
	let hasGenderDifferences: Bool
	let hatchCounter: Int
	let number: Int
	let isBaby: Bool
	let name: String
	let names: [LocalizedName]
	
	/// Placeholder init
	init() {
		identifier = UUID().uuidString
		baseHappiness = 0
		captureRate = 0
		color = .white
		eggGroups = []
		flavorTextEntries = []
		genderRate = nil
		genera = []
		generation = .i
		growthRate = ""
		hasGenderDifferences = false
		hatchCounter = 0
		number = 0
		isBaby = false
		name = ""
		names = []
	}
	
	/// Create a specie using PokeAPI data
	init(withData speciesData: PokemonSpeciesData) {
		identifier = UUID().uuidString
		baseHappiness = speciesData.base_happiness
		captureRate = speciesData.capture_rate
		growthRate = speciesData.growth_rate.name
		hasGenderDifferences = speciesData.has_gender_differences
		hatchCounter = speciesData.hatch_counter
		number = speciesData.id
		isBaby = speciesData.is_baby
		name = speciesData.name
		
		if speciesData.gender_rate < 0 || speciesData.gender_rate > 8 {
			genderRate = nil
		} else {
			genderRate = Double(speciesData.gender_rate / 8)
		}
		
		//TODO: Handle Nil coalescing in code below
		color = UIColor(named: speciesData.color.name) ?? .black
		generation = Generation(rawValue: speciesData.generation.name) ?? Generation.i
		
		var groups: [EggGroup] = []
		speciesData.egg_groups.forEach({ element in
			
			let newGroup = EggGroup(rawValue: element.name) ?? EggGroup.undiscovered
			groups.append(newGroup)
		})
		eggGroups = groups
		
		var entries: [FlavorTextEntry] = []
		speciesData.flavor_text_entries.forEach({ element in
			let lang = Language(rawValue: element.language.name) ?? Language.en
			let gver = GameVersion(rawValue: element.version.name) ?? GameVersion.red
			let newEntry = FlavorTextEntry(description: element.flavor_text, language: lang, version: gver)
			entries.append(newEntry)
		})
		flavorTextEntries = entries
		
		var newGenera: [Genus] = []
		speciesData.genera.forEach({ element in
			// TODO: Handle Nil coalescing
			let lang = Language(rawValue: element.language.name) ?? Language.en
			let newGenus = Genus(genus: element.genus, language: lang)
			newGenera.append(newGenus)
		})
		genera = newGenera
		
		var localizedNames: [LocalizedName] = []
		speciesData.names.forEach({ element in
			let lang = Language(rawValue: element.language.name) ?? Language.en
			let newName = LocalizedName(name: element.name, language: lang)
			localizedNames.append(newName)
		})
		names = localizedNames
	}
}

//extension Species: Persistable {
//	/// Create a Specie struct from a given Realm Object
//	public init(managedObject: SpeciesObject) {
//		identifier = managedObject.identifier
//		baseHappiness = managedObject.baseHappiness
//		captureRate = managedObject.captureRate
//		color = managedObject.color
//		eggGroups = managedObject.eggGroups
//		flavorTextEntries = managedObject.flavorTextEntries
//		genderRate = managedObject.genderRate
//		genera = managedObject.genera
//		generation = managedObject.generation
//		growthRate = managedObject.growthRate
//		hasGenderDifferences = managedObject.hasGenderDifferences
//		hatchCounter = managedObject.hatchCounter
//		number = managedObject.number
//		isBaby = managedObject.isBaby
//		name = managedObject.name
//		names = managedObject.names
//	}
//	
//	/// Returns the Realm Object implementation for the class.
//	func managedObject() -> SpeciesObject {
//		let species = SpeciesObject()
//		
//		species.identifier = identifier
//		species.baseHappiness = baseHappiness
//		species.captureRate = captureRate
//		species.color = color
//		species.eggGroups = eggGroups
//		species.flavorTextEntries = flavorTextEntries
//		species.genderRate = genderRate
//		species.genera = genera
//		species.generation = generation
//		species.growthRate = growthRate
//		species.hasGenderDifferences = hasGenderDifferences
//		species.hatchCounter = hatchCounter
//		species.number = number
//		species.isBaby = isBaby
//		species.name = name
//		species.names = names
//
//		return species
//	}
//}

/// Describes a Pokedex entry for a specific Pokémon form, in a given language for a specific game
struct FlavorTextEntry {
	let description: String
	let language: Language
	let version: GameVersion
}

/// Describes a Pokémon Genus, eg.: Fletchinder, the Ember Pokémon
struct Genus {
	let genus: String
	let language: Language
}

/// Describes a Pokémon name in a given language, eg.: Tyranitar, "en" or  バンギラス、"ja-ktkn"
struct LocalizedName {
	let name: String
	let language: Language
}
