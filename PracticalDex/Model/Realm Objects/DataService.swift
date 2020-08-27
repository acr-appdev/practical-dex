//
//  RealmUtils.swift
//  PracticalDex
//
//  Created by Allan Rosa on 30/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import Foundation
import RealmSwift

/// Responsible for Data transactions
public final class DataService {
	
	private init() {}
	static let shared = DataService() // Using a Singleton
	
	var realm = try! Realm()

	public func create<T: Persistable>(_ object: T) {
		do {
			try realm.write {
				realm.add(object.managedObject(), update: .modified)
			}
		} catch {
			post(error)
		}
    }
	
	public func create<T: Persistable>(_ objects: [T]) {
		do {
			try realm.write {
				// if objects.count == 0 { print("its nil dood")}
				objects.forEach({ object in
					// print("Writing \(object)")
					realm.add(object.managedObject(), update: .modified)
				})
			}
		} catch {
			print("something went wrong: \(error)")
			post(error)
		}
	}
	
	public func update<T: Object>(_ object: T, with dictionary: [String: Any?]){
		do {
			try realm.write {
				for (key, value) in dictionary {
					object.setValue(value, forKey: key)
				}
			}
		} catch {
			post(error)
		}
	}
	
	public func delete<T: Object>(_ object: T){
		do {
			try realm.write {
				realm.delete(object)
			}
		} catch {
			post(error)
		}

	}
	
	let realmErrorNotificationName = NSNotification.Name("RealmError")
	
	func post(_ error: Error){
		NotificationCenter.default.post(name: realmErrorNotificationName, object: error)
	}
	
	func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void){
		NotificationCenter.default.addObserver(forName: realmErrorNotificationName, object: nil, queue: nil) { (notification) in
			completion(notification.object as? Error)
		}
	}
	
	func stopObservingErrors(in vc: UIViewController){
		NotificationCenter.default.removeObserver(vc, name: realmErrorNotificationName, object: nil)
	}
	
}
