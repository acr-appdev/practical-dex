//
//  PokemonManager.swift
//  PracticalDex
//
//  Created by Allan Rosa on 11/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit
import RealmSwift

protocol PokedexManagerDelegate {
	// The delegate pattern protocol's requirements
	func didUpdatePokedexData(_ pokedexManager: PokedexManager)
	func didFinishFetchingPokemon(_ pokedexManager: PokedexManager)
	func didFinishFetchingSpecies(_ pokedexManager: PokedexManager)
	func didFailWithError(_ error: Error)
}

/**
Manages Pokedex entries and handles calls to PokeAPI [https://pokeapi.co/api/v2]
*/
class PokedexManager {
	
	// MARK: -- ATTRIBUTES --
	
	var delegate: PokedexManagerDelegate?
	var pokemonList: [Int : Pokemon] = [:] // Maps each pokemon to their number for ease of access
	var pokemonKeys: [Int] = [] // An array with the keys in pokemonList
	let pkmnGroup = DispatchGroup()
	private var pokemonFetchCounter = 0
	var finishedFetchingPokemon = false
	
	var speciesList: [Int : Species] = [:]
	let spcsGroup = DispatchGroup()
	private var speciesFetchCounter = 0
	var finishedFetchingSpecies = false
	
	// MARK: -- FUNCTIONS --
	// MARK: persist
	/// This is a function used to persist data in case there was a call to the API to fetch data (NOTE: Realm complains if its called outside the main thread so this function is public in order to be accessed from the PokedexViewController, which runs on the main thread)
	func persist(pokemonList savePokemonList: Bool = false, speciesList saveSpeciesList: Bool = false) {
		if savePokemonList {
			// Discarding the dictionary key value to store only the relevant data
			//print("=== Saving Pokémon === \n")
			//			pokemonList.forEach { (key, value) in
			//				let numberString = String(format: "%03d", key)
			//				print("Pokemon: \(numberString) \(value.name) ")
			//			}
			let lazyMapCollection = pokemonList.values
			let pkmnArray = Array(lazyMapCollection)
			DataService.shared.create(pkmnArray)
		}
		
		if saveSpeciesList {
			//print("saving species")
			let lazyMapCollection = speciesList.values
			let speciesArray = Array(lazyMapCollection)
			DataService.shared.create(speciesArray)
		}
	}
	
	// MARK: filter
	/// This is a function used to filter the current pokemonList being displayed, using the informed string.
	func filter(_ string: String){
		// treat string to convert it to nspredicate
		let predicate = NSPredicate(format: "name CONTAINS[cd] %@", string)
		
		pokemonKeys.removeAll()
		DataService.shared.retrieve(Pokemon.self, predicate: predicate, sorted: nil) { (retrievedData) in
			retrievedData.forEach { (pkmn) in
				pokemonKeys.append(pkmn.number)
			}
		}
		pokemonKeys.sort()
		delegate?.didUpdatePokedexData(self)
	}
	
	// MARK: restorePokemonList
	/// Restores the displayed pokemonList to the original list with all entries
	func restorePokemonList(){
		pokemonKeys = Array(pokemonList.keys.sorted())
		delegate?.didUpdatePokedexData(self)
	}
	
	// MARK: - fetchPokemon (Many)
	/**
	Fetches pokémon within the range of offset, informing the delegate with the API call result.
	*/
	private func fetchPokemon(fromNumber offset: Int, toNumber limit: Int){
		let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
		
		fetchData(urlString: urlString){ (result: Result<MultiplePokemonData, Error>) in
			switch result {
				case .success(let data):
					self.pkmnGroup.enter()
					self.pokemonFetchCounter = data.results.count
					data.results.forEach({ pkmn in
						
						self.pkmnGroup.enter()
						self.fetchPokemon(byName: pkmn.name, batch: true)
					})
					
				case .failure(let error):
					print("Failed to populate pokedex using limit=\(limit)&offset=\(offset) ", error)
					self.delegate?.didFailWithError(error)
			}
		}
	}
	
	// MARK: - fetchPokemon (Single)
	/// Fetches a **single** pokémon by its *name*, informing the delegate with the API call result.
	/// - Parameter name: The pokémon name to be fetched.
	/// - Parameter batch: Indicates if caller is in a batched fetch call.
	private func fetchPokemon(byName name: String, batch: Bool = false){
		let urlString = "https://pokeapi.co/api/v2/pokemon/\(name)"
		
		fetchData(urlString: urlString) { [self] (result: Result<PokemonData, Error>) in
			switch result {
				case .success(let pkmnData):
					let pkmn = Pokemon(withData: pkmnData)
					self.pokemonList[pkmn.number] = pkmn
					self.pokemonKeys = Array(self.pokemonList.keys.sorted())
					// This line lets the data be updated as it is retrieved
					self.delegate?.didUpdatePokedexData(self)
					
				case .failure(let error):
					print("Failed to fetch pokemon by name (\(name)): ", error)
					self.delegate?.didFailWithError(error)
			}
			
			if batch {
				self.pkmnGroup.leave()
				self.pokemonFetchCounter -= 1
				
				if self.pokemonFetchCounter == 0 {
					// .leave() an extra time to account for the .enter() on populatePokedex
					self.pkmnGroup.leave()
					self.pokemonKeys = Array(self.pokemonList.keys.sorted())
					self.delegate?.didFinishFetchingPokemon(self)
				}
			}
		}
	}
	
	// MARK: - fetchSpecies
	/**
	Fetches the pokémon species, informing the delegate with the call result.
	
	Use this method to fetch a single Species from the API, using either its id or name, where the *id* takes preference over the *name* if both are informed. If none are informed, the method returns before calling the API.
	
	- Parameter id: The pokemon number.
	- Parameter name: The pokemon name.
	
	- Warning: No input validation is done, since this method doesn't take inputs from the user. It still may fail, informing the delegate with the error.
	*/
	private func fetchSpecies(byNumber id: Int? = nil, byName name: String? = nil){
		var urlString = ""
		if id != nil {
			urlString = "https://pokeapi.co/api/v2/pokemon-species/\(id!)"
		} else if name != nil {
			urlString = "https://pokeapi.co/api/v2/pokemon-species/\(name!)"
		}
		if urlString == "" { return }
		
		fetchData(urlString: urlString){ (result: Result<PokemonSpeciesData, Error>) in
			switch result {
				case .success(let pkmnData):
					let species = Species(withData: pkmnData)
					self.speciesList[species.number] = species
				case .failure(let error):
					print("Failed to fetch species by number (\(id ?? -1)): ", error)
					self.delegate?.didFailWithError(error)
			}
			self.speciesFetchCounter -= 1
			if self.speciesFetchCounter <= 0 {
				self.delegate?.didFinishFetchingSpecies(self)
			}
		}
	}
	
	// MARK: - updateFetchStatus
	/**
	Updates the current status regarding data lists, linking relevant data.
	*/
	func updateFetchStatus(of fetchable: PokedexManagerFetchable){
		switch fetchable {
			case .Pokemon:
				finishedFetchingPokemon = true
			case .Species:
				finishedFetchingSpecies = true
		}
		
		if finishedFetchingPokemon && finishedFetchingSpecies {
			pokemonList.forEach { (key, pokemon) in
				//speciesList is an array, which is zero indexed
				//print("Key: \(key) Species: \(speciesList[key]?.name) Pkmn: \(pokemonList[key]?.name)")
				pokemonList[key]?.species = speciesList[key]
			}
		}
	}
	
	
	// MARK: - populatePokedex
	/**
	Fetches pokémon within the [*offset* ... *limit* range], based on their National Pokedex number
	
	This method should be called when the **PokedexManager** needs to be populated with data, i.e. when the app starts or when the user requests the data to be purged (See **resetData** method).
	
	The default value of *offset* is 0.
	
	The default value of *limit* is 898, as of *Pokémon Sword and Shield - The Crown Tundra*.
	
	- Parameter offset: Lower bound of the pokemon range to be fetched.
	- Parameter limit: Upper Bound of the pokemon range to be fetched.
	*/
	func populatePokedex(fromNumber offset: Int = 0, toNumber limit: Int = 898){
		// Retrieve from database if populated, else fetch data from pokeAPI
		let sortParameter = Sorted(key: "number", ascending: true)
		DataService.shared.retrieve(Pokemon.self, sorted: sortParameter) { (retrievedList) in
			
			retrievedList.forEach({ pkmn in
				self.pokemonList[pkmn.number] = pkmn
			})
		}
		
		DataService.shared.retrieve(Species.self, sorted: sortParameter) { (retrievedList) in
			retrievedList.forEach { (species) in
				self.speciesList[species.number] = species
			}
		}
		
		pokemonKeys = Array(pokemonList.keys.sorted())
		
		// Check if the pokemonList.count is the correct amount of pokemon
		let check = limit-offset
		if self.pokemonList.count != check || self.speciesList.count != check {
			
			var fetchRangeLowerBound = offset
			if offset == 0 { fetchRangeLowerBound = 1 } // There is no pokemon numbered as 0
			let fetchRange = Set(fetchRangeLowerBound...limit)
			
			// Sometimes there are PokeAPI entries that doesn't return valid JSON, even when they should.
			// In order to deal with that, we might need to try to fetch entries that didn't receive an answer after the app's first launch call to populatePokedex
			let notFetchedEntries = fetchRange.subtracting(pokemonKeys)
			
			pkmnGroup.enter() // Batching fetchPokemon
			notFetchedEntries.forEach({
				self.pkmnGroup.enter()
				self.pokemonFetchCounter = notFetchedEntries.count
				fetchPokemon(byName: String($0), batch: true)
				
				self.speciesFetchCounter = notFetchedEntries.count
				fetchSpecies(byNumber: $0)
			})
			
		}
		// There was correct data stored in the database
		else {
			print("No need to fetch from API")
			pokemonKeys.forEach { (key) in
				pokemonList[key]?.species = speciesList[key]
			}
		}
	}
	
	// MARK: - resetData
	/** Resets the PokedexManager loaded data lists.
	- Parameter purgeDatabase: Invokes the deleteAll method from DataService to reset the database.
	*/
	func resetData(purgeDatabase: Bool = false){
		pokemonKeys.removeAll()
		pokemonList.removeAll()
		finishedFetchingPokemon = false
		
		speciesList.removeAll()
		finishedFetchingSpecies = false
		
		if purgeDatabase {
			DataService.shared.deleteAll()
		}
	}
}

enum PokedexManagerFetchable {
	case Pokemon
	case Species
}
