//
//  SpeciesObject.swift
//  PracticalDex
//
//  Created by Allan Rosa on 30/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import RealmSwift

/**
Stores a Realm object of the *Species* class.

- **generaPropertyName**: Used to refer to the Attribute `genera`
- **generaAsArray**: Get `genera` as `Array`
- **textEntriesPropertyName**: Used to refer to the attribute `flavorTextEntries`
*/
final class SpeciesObject: Object {
	// TODO: Check if PropertyName / AsArray solution can be refactored into a RealmSwift extension (getArray is an extension defined in Persistable)
	@objc dynamic var number: Int = 0
	@objc dynamic var name: String = ""
	@objc dynamic var genderRate: Double = -1
	let genera = List<GenusObject>()
	static let generaPropertyName = "genera"
	var generaAsArray: [Genus] { get { return getArray(fromPropertyType: Genus.self, named: SpeciesObject.generaPropertyName) } }
	let flavorTextEntries = List<FlavorTextEntryObject>()
	static let textEntriesPropertyName = "flavorTextEntries"
	var flavorTextAsArray: [FlavorTextEntry] { get { return getArray(fromPropertyType: FlavorTextEntry.self, named: SpeciesObject.textEntriesPropertyName) } }
	
//	@objc dynamic var baseHappiness: Int = 0
//	@objc dynamic var captureRate: Int = 0
//	@objc dynamic var color: String = ""
//	@objc dynamic var eggGroups: [EggGroup] = []
//	@objc dynamic var generation: Generation = .i
//	@objc dynamic var growthRate: String = ""
//	@objc dynamic var hasGenderDifferences: Bool = false
//	@objc dynamic var hatchCounter: Int = 0
//	@objc dynamic var isBaby: Bool = false
//	@objc dynamic var names: [LocalizedName] = []
	
	override static func primaryKey() -> String? {
		return "number"
	}
	
	convenience init(withSpecies species: Species){
		self.init()
		number = species.number
		name = species.name
		genderRate = species.genderRate ?? -1
	}
}

