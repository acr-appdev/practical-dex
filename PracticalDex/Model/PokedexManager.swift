//
//  PokemonManager.swift
//  PracticalDex
//
//  Created by Allan Rosa on 11/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit
import RealmSwift
//import Network

protocol PokedexManagerDelegate {
	// The delegate pattern protocol's requirements
	// didRetrievePokemon: Who updated the pokedex? What is the updated data?
	func didRetrievePokemon(_ pokedexManager: PokedexManager, pokemon: Pokemon)
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
	
	var pokemonList: [Int : Pokemon] = [:] // [pokemon.number : pokemon]
	let pkmnGroup = DispatchGroup()
	private var pokemonFetchCounter = 0
	var finishedFetchingPokemon = false
	
	var speciesList: [Species] = [] // [species.number : species]
	let spcsGroup = DispatchGroup()
	private var speciesFetchCounter = 0
	var finishedFetchingSpecies = false
	
	// MARK: -- FUNCTIONS --
	/// This is a function used to persist data in case there was a call to the API to fetch data (NOTE: Realm complains if its called outside the main thread so this function is public in order to be accessed from the PokedexViewController, which runs on the main thread)
	func persist(pokemonList savePokemonList: Bool = false, speciesList saveSpeciesList: Bool = false) {
		if savePokemonList {
//			print("===== Persisting Pokemon Data [\(pokemonList.count)] ======")
//			pokemonList.forEach({ pkmn in print("[Pokemon] \(pkmn.value.name)") })
//			print("============================")
			
			// Discarding the key value to store only the relevant data
			let lazyMapCollection = pokemonList.values
			let pkmnArray = Array(lazyMapCollection)
			
			DataService.shared.create(pkmnArray)
		}
		
		if saveSpeciesList {
//			print("===== Persisting Species Data [\(speciesList.count)] ======")
//			speciesList.forEach({species in print("[Species] \(species.name)") })
//			print("============================")
			
			DataService.shared.create(speciesList)
		}
	}
	
	// MARK: - fetchPokemon (Many)
	/**
	Fetches pokémon within the range of offset, informing the delegate with the API call result, batch parameter is used to indicate if this method is being called by fetchPokemon fromNumber toNumber
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

		fetchData(urlString: urlString) { (result: Result<PokemonData, Error>) in
			switch result {
				case .success(let pkmnData):
					let pkmn = Pokemon(withData: pkmnData)
					self.pokemonList[pkmn.number] = pkmn
					// self.pokemonList.append(pkmn)
					// This updates the data as it is retrieved
					self.delegate?.didRetrievePokemon(self, pokemon: pkmn)
					
				case .failure(let error):
					print("Failed to fetch pokemon by name (\(name)): ", error)
					self.delegate?.didFailWithError(error)
			}
			
			if batch {
				self.pkmnGroup.leave()
				self.pokemonFetchCounter -= 1
				if self.pokemonFetchCounter == 0 {
					self.pkmnGroup.leave() // .leave() an extra time to account for the .enter() on populatePokedex
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
		//print(urlString)
		if urlString == "" { return }
		
		fetchData(urlString: urlString){ (result: Result<PokemonSpeciesData, Error>) in
			switch result {
				case .success(let pkmnData):
					let specie = Species(withData: pkmnData)
					//print("[Retrieved Species] #\(specie.number) - \(specie.name)")
					self.speciesList.append(specie)
				
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
	func updateFetchStatus(_ fetchable: PokedexManagerFetchable){
		switch fetchable {
			case .Pokemon: finishedFetchingPokemon = true
			case .Species: finishedFetchingSpecies = true
		}
		
		if finishedFetchingPokemon && finishedFetchingSpecies {
			pokemonList.forEach { (key, pokemon) in
				pokemonList[key]?.species = speciesList[key-1]
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
		// retrieve from database if populated, else fetch data from pokeAPI
		
		let sortParameter = Sorted(key: "number", ascending: true)
		DataService.shared.retrieve(Pokemon.self, sorted: sortParameter) { (retrievedList) in
			// self.pokemonList = retrievedList
			retrievedList.forEach({ pkmn in
				self.pokemonList[pkmn.number] = pkmn
			})
		}
		
		DataService.shared.retrieve(Species.self, sorted: sortParameter) { (retrievedList) in
			self.speciesList = retrievedList
//			retrievedList.forEach({ pkmn in
//				self.pokemonList[pkmn.number] = pkmn
//			})
		}
		
		let check = limit-offset
		
		print("Check: \(check) != Pkmn: \(self.pokemonList.count) != Spcs:  \(self.speciesList.count)")
		if self.pokemonList.count != check || self.speciesList.count != check {
			
			DataService.shared.deleteAll()
			pokemonList.removeAll()
			speciesList.removeAll()
			
			fetchPokemon(fromNumber: offset, toNumber: limit)
			
			speciesFetchCounter = limit-offset
			
			var lowerBound = offset
			if lowerBound == 0 { lowerBound = 1 }
			for i in lowerBound...limit {
				fetchSpecies(byNumber: i)
			}
			
		} else {
			delegate?.didFinishFetchingPokemon(self)
			delegate?.didFinishFetchingSpecies(self)
		}
	}
	
	// MARK: - resetData
	/** Resets the PokedexManager loaded data lists.
	- Parameter purgeDatabase: Invokes the deleteAll method from DataService to reset the database.
	*/
	func resetData(purgeDatabase: Bool = false){
		pokemonList.removeAll()
		finishedFetchingPokemon = false
		speciesList.removeAll()
		finishedFetchingSpecies = false
		
		
		if purgeDatabase {
			DataService.shared.deleteAll()
		}
		
		// REVIEW
		self.delegate?.didFinishFetchingPokemon(self)
	}
}

enum PokedexManagerFetchable {
	case Pokemon
	case Species
}
