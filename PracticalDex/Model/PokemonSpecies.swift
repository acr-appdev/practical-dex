//
//  PokemonSpecies.swift
//  PracticalDex
//
//  Created by Allan Rosa on 26/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

struct PokemonSpecies {
	let baseHappiness: Int
	let captureRate: Int
	let color: UIColor
	let eggGroups: [EggGroup]
	// let evolution_chain: UnnamedAPIResource
	// let evolves_from_species: EvolvesFromSpeciesData
	let flavorTextEntries: [FlavorTextEntry]
	//let form_descriptions: [FormDescriptionsData]
	//let forms_switchable: Bool
	let genderRate: Double? // percentage value, nil = genderless
	let genera: [Genus]
	let generation: Generation
	let growthRate: String // https://pokeapi.co/api/v2/growth-rate/
	//let habitat:
	let hasGenderDifferences: Bool
	let hatchCounter: Int
	let number: Int
	let isBaby: Bool
	let name: String
	let names: [LocalizedName]
	let order: Int
	// let pal_park_encounters:
	// let pokedex_numbers:
	// let shape:
	// let varieties:
	
}

extension PokemonSpecies {
	
	init(withData speciesData: PokemonSpeciesData) {
		baseHappiness = speciesData.base_happiness
		captureRate = speciesData.capture_rate
		growthRate = speciesData.growth_rate.name
		hasGenderDifferences = speciesData.has_gender_differences
		hatchCounter = speciesData.hatch_counter
		number = speciesData.id
		isBaby = speciesData.is_baby
		name = speciesData.name
		order = speciesData.order
		
		if speciesData.gender_rate < 0 || speciesData.gender_rate > 8 {
			genderRate = nil
		} else {
			genderRate = Double(speciesData.gender_rate / 8)
		}
		
		// TODO: Handle Nil coalescing in code below
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

struct FlavorTextEntry {
	let description: String
	let language: Language
	let version: GameVersion
}

struct Genus {
	let genus: String
	let language: Language
}

struct LocalizedName {
	let name: String
	let language: Language
}
