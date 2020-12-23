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
