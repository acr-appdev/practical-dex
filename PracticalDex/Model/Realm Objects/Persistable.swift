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
	associatedtype ManagedObject: Object
	
	init(managedObject: ManagedObject)
	func managedObject() -> ManagedObject
	
}
