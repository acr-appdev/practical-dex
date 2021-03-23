//
//  AbilityObject.swift
//  PracticalDex
//
//  Created by Allan Rosa on 01/09/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import RealmSwift

final class AbilityObject: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var isHidden: Bool = false

	override static func primaryKey() -> String? {
		return "name"
	}
}




