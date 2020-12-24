//
//  Persistable.swift
//  PracticalDex
//
//  Created by Allan Rosa on 19/08/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import Foundation
import RealmSwift

public protocol Persistable {
	/// **ManagedObject** inherits from Object, defined in RealmSwift framework
	associatedtype ManagedObject: Object
	
	/// Creates a new Swift Object given a RealmObject
	init(managedObject: ManagedObject)
	
	/// Returns the RealmObject implementation for the class.
	func managedObject() -> ManagedObject
	
}

extension Object {
	func getArray<T:Persistable>(fromPropertyType type: T.Type, named name: String) -> [T] {
		let realmListProperty = self.value(forKey: name) as! RealmSwift.List<T.ManagedObject>
		//print(realmListProperty)
		let realmObjectArray = Array(realmListProperty)
		
		var returnArray: [T] = []
		
		realmObjectArray.forEach({ object in
			let newItem = T(managedObject: object)
			returnArray.append(newItem)
		})

		return returnArray
	}
}
