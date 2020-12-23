//
//  SpeciesObject.swift
//  PracticalDex
//
//  Created by Allan Rosa on 30/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import RealmSwift

final class SpeciesObject: Object {
	@objc dynamic var number: Int = 0
	@objc dynamic var name: String = ""
	@objc dynamic var genderRate: Double = -1
	let genera = List<GenusObject>()
	static let generaPropertyName = "genera"
	let flavorTextEntries = List<FlavorTextEntryObject>()
	static let textEntriesPropertyName = "flavorTextEntries"
	
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
	
	func getGenera() -> [Genus] {
		let generaObjectArray = Array(genera)
		var generaArray: [Genus] = []
		generaObjectArray.forEach({ genusObject in
			generaArray.append( Genus(managedObject: genusObject) )
		})
		
//		print("---- GETGENERA YIELDS: ----")
//		generaArray.forEach { k in
//			print("[\(k.language)] \(k.genusDescription)")
//		}
		return generaArray
	}
	
	func getTextEntries() -> [FlavorTextEntry] {
		var returnArray: [FlavorTextEntry] = []
		let realmObjectArray = Array(flavorTextEntries)
		
		realmObjectArray.forEach({ object in
			let newItem = FlavorTextEntry(managedObject: object)
			returnArray.append(newItem)
		})
		
		return returnArray
	}
	
	/* TODO: Create generic version of getArray
	func getArray<T: Persistable>(ofProperty property: String) -> Any {
		let realmObjectArray = Array(\.property)
		
		var returnArray: [T] = []
		
		realmObjectArray.forEach({ object in
			
			let newItem = T(managedObject: object)
			
			returnArray.append(newItem)
		})

		return returnArray
	}
	*/
}

class GenusObject: Object {
	@objc dynamic var genusDescription: String = ""
	@objc dynamic var language: String = ""
	let ofSpecies = LinkingObjects(fromType: SpeciesObject.self, property: SpeciesObject.generaPropertyName)
}

class FlavorTextEntryObject: Object {
	@objc dynamic var flavorTextDescription: String = ""
	@objc dynamic var language: String = ""
	@objc dynamic var version: String = ""
	let ofSpecies = LinkingObjects(fromType: SpeciesObject.self, property: SpeciesObject.textEntriesPropertyName)
}

class LocalizedNameObject: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var language: String = ""
}
