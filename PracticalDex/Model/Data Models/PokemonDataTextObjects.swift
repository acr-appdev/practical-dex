//
//  PokemonDataTextObjects.swift
//  PracticalDex
//
//  Created by Allan Rosa on 23/12/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import RealmSwift

final class GenusObject: Object {
	@objc dynamic var genusDescription: String = ""
	@objc dynamic var language: String = ""
	let ofSpecies = LinkingObjects(fromType: SpeciesObject.self, property: SpeciesObject.generaPropertyName)
}

final class FlavorTextEntryObject: Object {
	@objc dynamic var flavorTextDescription: String = ""
	@objc dynamic var language: String = ""
	@objc dynamic var version: String = ""
	let ofSpecies = LinkingObjects(fromType: SpeciesObject.self, property: SpeciesObject.textEntriesPropertyName)
}

final class LocalizedNameObject: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var language: String = ""
}

