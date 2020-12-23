//
//  AppDelegate.swift
//  PracticalDex
//
//  Created by Allan Rosa on 10/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		let defaults = UserDefaults.standard
		
		print(Realm.Configuration.defaultConfiguration.fileURL as Any)
		
		Realm.Configuration.defaultConfiguration = Realm.Configuration(
			// Set the new schema version. This must be greater than the previously used
			// version (if you've never set a schema version before, the version is 0).
			schemaVersion: 1,
			
			// Set the block which will be called automatically when opening a Realm with
			// a schema version lower than the one set above
			migrationBlock: { migration, oldSchemaVersion in
				print("___ PERFOMING MIGRATION ___")
				if oldSchemaVersion < 1 {
					migration.enumerateObjects(ofType: PokemonObject.className()) { (oldObject, newObject) in
						newObject!["height"] = 0.0
						newObject!["weight"] = 0.0
					}
				}
			})
		
		if !defaults.bool(forKey: K.App.Defaults.hasLaunchedBefore) {
			print(" ˜˜˜˜˜˜˜˜˜˜˜˜˜ \n First Launch \n ˜˜˜˜˜˜˜˜˜˜˜˜˜ ")
				setUserDefaults()
		}
		
		if let bgmName = defaults.string(forKey: K.App.Defaults.selectedBGM) {
			playBGM(sound: bgmName, type: "mp3")
		}
		
		return true
	}
	
	// MARK: UISceneSession Lifecycle
	
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
	
	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
}

