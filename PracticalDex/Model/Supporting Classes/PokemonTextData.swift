//
//  PokemonTextData.swift
//  PracticalDex
//
//  Created by Allan Rosa on 08/12/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import Foundation

/// Describes a Pokémon Genus, e.g.: ["Ember Pokémon, en]
struct Genus {
	let genusDescription: String
	let language: Language
}

/// Describes a Pokedex entry for a specific Pokémon form, in a given language for a specific game
struct FlavorTextEntry {
	let flavorTextDescription: String
	let language: Language
	let version: GameVersion
}

/// Describes a Pokémon name in a given language, e.g.: ["Tyranitar", en] or  ["バンギラス"、ja-ktkn]
struct LocalizedName {
	let name: String
	let language: Language
}

//MARK: -- PERSISTABLE --
extension Genus: Persistable {
	public init(managedObject: GenusObject) {
		genusDescription = managedObject.genusDescription
		language = Language(rawValue: managedObject.language) ?? .en
	}
	
	func managedObject() -> GenusObject {
		let genusObject = GenusObject()
		genusObject.genusDescription = genusDescription
		genusObject.language = language.rawValue
		
		return genusObject
	}
}

extension FlavorTextEntry: Persistable {
	public init(managedObject: FlavorTextEntryObject){
		flavorTextDescription = managedObject.flavorTextDescription
		language = Language(rawValue: managedObject.language) ?? .en
		version = GameVersion(rawValue: managedObject.version) ?? .red
	}
	
	func managedObject() -> FlavorTextEntryObject {
		let flavorTextEntryObject = FlavorTextEntryObject()
		flavorTextEntryObject.flavorTextDescription = flavorTextDescription
		flavorTextEntryObject.language = language.rawValue
		flavorTextEntryObject.version = version.rawValue
		
		return flavorTextEntryObject
	}
}
