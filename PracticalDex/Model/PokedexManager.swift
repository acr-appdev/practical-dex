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
	func didFinishPopulatingPokedex(_ pokedexManager: PokedexManager)
	func didFailWithError(_ error: Error)
}

/// Manages Pokedex entries and handles calls to PokeAPI (https://pokeapi.co/api/v2)
class PokedexManager {
	
	// MARK: -- ATTRIBUTES --
	
	var pokemonList: [Pokemon] = []
	let pkmnGroup = DispatchGroup()
	var delegate: PokedexManagerDelegate?
	private var counter = 0
	var dataNeedsPersistence = false
	
	// MARK: -- INIT --
	// No custom Init
	
	// MARK: -- FUNCTIONS --
	
	/// This is a function used to persist data in case there was a call to the API to fetch data (NOTE: Realm complains if its called outside the main thread so this function is public in order to be accessed from the PokedexViewController, which runs on the main thread)
	func persist() {
		if dataNeedsPersistence {
			DataService.shared.create(pokemonList)
			dataNeedsPersistence = false
		}
	}
	
	// MARK: - fetchPokemon
	/// Fetches a single pokémon by its (name), informing the delegate with the API call result, batch parameter is used to indicate if this method is being called by fetchPokemon fromNumber toNumber
	func fetchPokemon(byName name: String, batch: Bool = false){
		let urlString = "https://pokeapi.co/api/v2/pokemon/\(name)"
		
		fetchData(urlString: urlString) { (result: Result<PokemonData, Error>) in
			switch result {
				case .success(let pkmnData):
					let pkmn = Pokemon(withData: pkmnData)
					self.pokemonList.append(pkmn)
					
					if batch {
						self.pkmnGroup.leave()
						self.counter -= 1
						if self.counter == 0 {
							self.pkmnGroup.leave() // .leave() an extra time to account for the .enter() on populatePokedex
							UserDefaults.standard.set(true, forKey: K.App.Defaults.databaseIsPopulated)
							self.delegate?.didFinishPopulatingPokedex(self)
						}
					}
					self.delegate?.didRetrievePokemon(self, pokemon: pkmn)
				
				case .failure(let error):
					print("Failed to fetch pokemon by name (\(name)): ", error)
					if batch { self.pkmnGroup.leave() }
					self.delegate?.didFailWithError(error)
			}
		}
	}
	
	func fetchPokemon(fromNumber offset: Int, toNumber limit: Int){
		let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
		
		fetchData(urlString: urlString){ (result: Result<MultiplePokemonData, Error>) in
			switch result {
				case .success(let data):
					self.pkmnGroup.enter()
					self.counter = data.results.count
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
	
	// MARK: - fetchSpecies
	/// Fetches the pokémon species of number (id), informing the delegate with the call result
	func fetchSpecies(byNumber id: Int){
		let urlString = "https://pokeapi.co/api/v2/pokemon-species/\(id)"
		
		fetchData(urlString: urlString){ (result: Result<PokemonSpeciesData, Error>) in
			switch result {
				case .success(let pkmnData):
					let species = Species(withData: pkmnData)
					print(species)
					//pokemonEntries.forEach( {(pkmn) in print(pkmn.name)} )
				case .failure(let error):
					print("Failed to fetch pokemon by number (\(id)): ", error)
					self.delegate?.didFailWithError(error)
			}
		}
	}
	
	// MARK: - populatePokedex
	/// Fetches (limit) pokémon, starting from (offset), based on their National Pokedex number
	func populatePokedex(fromNumber offset: Int = 0, toNumber limit: Int = 800){
		// retrieve from database if populated, else fetch data from pokeAPI
		if UserDefaults.standard.bool(forKey: K.App.Defaults.databaseIsPopulated){
			let sortParameter = Sorted(key: "number", ascending: true)
			DataService.shared.retrieve(Pokemon.self, sorted: sortParameter) { (retrievedList) in
				self.pokemonList = retrievedList
			}
			delegate?.didFinishPopulatingPokedex(self)
		} else {
			dataNeedsPersistence = true
			fetchPokemon(fromNumber: offset, toNumber: limit)
		}
	}
	
	// MARK: - resetData
	/// Resets the loaded data, purges the database if purgeDatabase is true
	func resetData(purgeDatabase: Bool = false){
		pokemonList.removeAll()
		
		if purgeDatabase {
			DataService.shared.deleteAll()
			UserDefaults.standard.setValue(false, forKey: K.App.Defaults.databaseIsPopulated)
		}
		self.delegate?.didFinishPopulatingPokedex(self)
	}
	
}
