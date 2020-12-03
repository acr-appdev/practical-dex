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

	// MARK: - Create
	public func create<T: Persistable>(_ object: T) {
		do {
			try realm.write {
				realm.add(object.managedObject(), update: .modified)
			}
		} catch {
			post(error)
		}
    }
	
	// MARK: - Create
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
			post(error)
		}
	}
	
	// MARK: - Retrieve
	public func retrieve<T: Persistable>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil, completion: (([T]) -> ())) {
		
		var objects = self.realm.objects(model.ManagedObject)
		
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        
        if let sorted = sorted {
            objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }
		
		var modelObjects: [T] = []
		
		objects.forEach({ object in
			let newModelObject: T
			newModelObject = T(managedObject: object)
			
			modelObjects.append(newModelObject)
		})
		
		completion(modelObjects)
    }
	
	// MARK: - Update
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
	
	// MARK: - Delete
	public func delete<T: Object>(_ object: T){
		do {
			try realm.write {
				realm.delete(object)
			}
		} catch {
			post(error)
		}
	}
	
	// MARK: - DeleteAll
	public func deleteAll(){
		do {
			try realm.write({
				realm.deleteAll()
				print("purged!!!!!")
			})
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

public struct Sorted {
  var key: String
  var ascending: Bool = true
}
