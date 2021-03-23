//
//  Persistable.swift
//  PracticalDex
//
//  Created by Allan Rosa on 19/08/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import Foundation
import RealmSwift

/**
A `Persistable` class or struct must also implement a corresponding `ManagedObject` to be persisted in the Database, such as Realm.

Define an `init` method that initializes the class from its `ManagedObject`, as well as a `managedObject()` function to return the `ManagedObject` to be stored in the database.
*/
public protocol Persistable {
	/// **ManagedObject** inherits from Object, defined in RealmSwift framework
	associatedtype ManagedObject: Object
	
	/// Creates a new Swift Object given a RealmObject
	init(managedObject: ManagedObject)
	
	/// Returns the RealmObject implementation for the class.
	func managedObject() -> ManagedObject
	
}

extension Object {
	/** Returns `RealmSwift.List` properties as plain Swift `Array`.
	- Parameters:
		- type: The object's property type which is declared as a `RealmSwift.List`.
		- name: The name of the property.
	- Returns: An Array of the informed property `type`.
	*/
	func getArray<T:Persistable>(fromPropertyType type: T.Type, named name: String) -> [T] {
		let realmListProperty = self.value(forKey: name) as! RealmSwift.List<T.ManagedObject>

		let realmObjectArray = Array(realmListProperty)

		var returnArray: [T] = []
		
		realmObjectArray.forEach({ object in
			let newItem = T(managedObject: object)
			returnArray.append(newItem)
		})
		return returnArray
	}
}
