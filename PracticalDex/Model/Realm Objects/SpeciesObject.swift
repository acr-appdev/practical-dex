//
//  SpeciesObject.swift
//  PracticalDex
//
//  Created by Allan Rosa on 30/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import RealmSwift

final class SpeciesObject: Object {
	@objc dynamic var identifier: String = UUID().uuidString
//	@objc dynamic var baseHappiness: Int = 0
//	@objc dynamic var captureRate: Int = 0
//	@objc dynamic var color: UIColor = .black
//	@objc dynamic var eggGroups: [EggGroup] = []
//	@objc dynamic var flavorTextEntries: [FlavorTextEntry] = []
//	@objc dynamic var genderRate = RealmOptional<Double>()
//	@objc dynamic var genera: [Genus] = []
//	@objc dynamic var generation: Generation = .i
//	@objc dynamic var growthRate: String = ""
//	@objc dynamic var hasGenderDifferences: Bool = false
//	@objc dynamic var hatchCounter: Int = 0
	@objc dynamic var number: Int = 0
	@objc dynamic var isBaby: Bool = false
	@objc dynamic var name: String = ""
//	@objc dynamic var names: [LocalizedName] = []
	
	override static func primaryKey() -> String? {
		return "number"
	}
	
	convenience init(withSpecies species: Species){
		self.init()
		number = species.number
		isBaby = species.isBaby
		name = species.name
	}
	
}

class FlavorTextEntryObject: Object {
	let flavorTextDescription: String = ""
	let language: Language = .en
	let version: GameVersion = .red
}

class GenusObject: Object {
	let genus: String = ""
	let language: Language = .en
}

struct LocalizedNameObject {
	let name: String
	let language: Language
}
