//
//  RealmUtils.swift
//  PracticalDex
//
//  Created by Allan Rosa on 30/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import Foundation
import RealmSwift

/**
Encapsulates Data transactions, separating the Data Access Layer from the Business Model and Presentation Layers.

Every transaction (except `retrieve`) catches possible errors and posts them, use `observeRealmErrors` and `stopObservingErrors` in ViewControllers which invokes any failable transaction method.

- Warning: This class uses a singleton to manage all transactions.
*/
public final class DataService {
	
	private init() {}
	static let shared = DataService() // Using a Singleton
	
	var realm = try! Realm()

	// MARK: create (Single Object)
	/**
	Adds a single instance of a `Persistable` class to the current Realm.
		
	This method tries to open a Realm write transaction and then add the corresponding `managedObject` to the Realm, using the specified `updatePolicy`.
	
	If using the default `updatePolicy`, objects are required to have their primary keys specified.
	
	- Parameters:
		- object: The instance to be added to the database.
		- updatePolicy: The update policy to be used when determining how the object should be added. [Realm.UpdatePolicy](https://realm.io/docs/swift/latest/api/Classes/Realm/UpdatePolicy.html)
	
	- Warning: Realm Errors are **not** handled, and instead are posted to `NotificationCenter`, use the methods `observeRealmErrors` and `stopObservingErrors` to capture and handle them.
	*/
	public func create<T: Persistable>(_ object: T, updatePolicy: Realm.UpdatePolicy = .modified) {
		do {
			try realm.write {
				realm.add(object.managedObject(), update: updatePolicy)
			}
		} catch {
			post(error)
		}
    }
	
	// MARK: - create (Array of Objects)
	/**
	Adds an array of `Persistable` objects to the current Realm.
	
	This method tries to open a Realm write transaction and then add the corresponding `managedObject` to the Realm, using the specified `updatePolicy`.
	
	If using the default `updatePolicy`, objects are required to have their primary keys specified.
	
	- Parameters:
		- objects: The array of `Persistable` objects to be persisted.
		- updatePolicy: The update policy to be used when determining how the object should be added. [Realm.UpdatePolicy](https://realm.io/docs/swift/latest/api/Classes/Realm/UpdatePolicy.html)
	
	- Warning: Realm Errors are **not** handled, and instead are posted to `NotificationCenter`, use the methods `observeRealmErrors` and `stopObservingErrors` to capture and handle them.
	*/
	public func create<T: Persistable>(_ objects: [T], updatePolicy: Realm.UpdatePolicy = .modified) {
		do {
			try realm.write {
				// if objects.count == 0 { print("its nil dood")}
				objects.forEach({ object in
					// print("Writing \(object)")
					realm.add(object.managedObject(), update: updatePolicy)
				})
			}
		} catch {
			post(error)
		}
	}
	
	// MARK: - retrieve
	/**
	Retrieves `model` objects from the current Realm, providing a completion handler with an Array of retrieved items.
	
	All objects are retrieved at first, filtering them by `predicate` and sorting with the custom struct `sorted`.  Then, the remaining objects are converted to their business model structs, and appended to an array, passed to the returning `completion` handler.
	
	- Parameters:
	   - model: The business model struct, which conforms to `Persistable`, to be retrieved
	   - predicate: A `NSPredicate` to filter the queried objects.
	   - sorted: The key and order to sort the objects.
	   - completion: A returning completion handler with the retrieved, filtered and sorted objects.
	*/
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
	
	// MARK: - update
	/**
	Updates a Realm `object `, using a `dictionary` containing it's properties/values to be updated.
	
	This method tries to open a write transaction, following the
	
	- Parameters:
		- object: The object to be updated.
		- dictionary: A collection where *keys* are the object's properties names and *values* are the object's properties values.
	
	- Warning: Realm Errors are **not** handled, and instead are posted to `NotificationCenter`, use the methods `observeRealmErrors` and `stopObservingErrors` to capture and handle them.
	*/
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
	
	// MARK: - delete
	/**
	Deletes an `object ` from the current Realm.
	
	- Parameters:
		- object: The object to be deleted.
	
	- Warning: Realm Errors are **not** handled, and instead are posted to `NotificationCenter`, use the methods `observeRealmErrors` and `stopObservingErrors` to capture and handle them.
	*/
	public func delete<T: Object>(_ object: T){
		do {
			try realm.write {
				realm.delete(object)
			}
		} catch {
			post(error)
		}
	}
	
	// MARK: - deleteAll
	/**
	Deletes **everything** in the Realm database.
	USE WITH CAUTION!!
	
	- Warning: Realm Errors are **not** handled, and instead are posted to `NotificationCenter`, use the methods `observeRealmErrors` and `stopObservingErrors` to capture and handle them.
	*/
	public func deleteAll(){
		do {
			try realm.write({
				realm.deleteAll()
			})
		} catch {
			post(error)
		}
	}
	
	// MARK: -- Error Handling --
	let realmErrorNotificationName = NSNotification.Name("RealmError")
	
	// MARK: post
	/**
	Posts a notification to the `NotificationCenter`, under the *RealmError* name, of the `Error` object.
	
	- Parameters:
		- error: The error object caught.
	*/
	func post(_ error: Error){
		NotificationCenter.default.post(name: realmErrorNotificationName, object: error)
	}
	
	// MARK: - observeRealmErrors
	/**
	Starts observing Realm Errors in the viewController, providing an escaping completion handler with the Error object.
	
	- Parameters:
		- vc: The view controller to be observed.
		- completion: The escaping completion handler, which has the posted `error` as an input parameter.
	*/
	func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void){
		NotificationCenter.default.addObserver(forName: realmErrorNotificationName, object: nil, queue: nil) { (notification) in
			completion(notification.object as? Error)
		}
	}
	
	// MARK: - stopObservingErrors
	/**
	Stops observing Realm Errors in the View Controller.
	
	- Parameters:
		- vc: The view controller to stop being observed.
	*/
	func stopObservingErrors(in vc: UIViewController){
		NotificationCenter.default.removeObserver(vc, name: realmErrorNotificationName, object: nil)
	}
	
}

// MARK: - Sorted Struct
/**
A simple struct to determine how to sort queries.

- Properties:
	- `key`: The property name to determine the sorting order.
	- `ascending: Defaults to `true`. Set to `false` to sort in descending order.
*/
public struct Sorted {
	var key: String
	var ascending: Bool = true
}
