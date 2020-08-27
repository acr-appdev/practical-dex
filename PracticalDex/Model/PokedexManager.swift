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
	// didRetrievePokemon: Who updated the pokedex? What is the updated data?
	func didRetrievePokemon(_ pokedexManager: PokedexManager, pokemon: Pokemon)
	func didFinishPopulatingPokedex(_ pokedexManager: PokedexManager)
	func didFailWithError(_ error: Error)
}

/// Manages Pokedex entries and handles calls to PokeAPI (https://pokeapi.co/api/v2)
class PokedexManager {
	var pokemonList: [Pokemon] = []
	var isPopulating = false
	let pkmnGroup = DispatchGroup()
	var delegate: PokedexManagerDelegate?
	var counter = 0
	
	func persist() {
		DataService.shared.create(pokemonList)
	}
	
	// MARK: - fetchPokemon
	/// Fetches the pokémon with (name), informing the delegate with the call result
	func fetchPokemon(byName name: String, batch: Bool = false){
		let urlString = "https://pokeapi.co/api/v2/pokemon/\(name)"

		fetchData(urlString: urlString){ (result: Result<PokemonData, Error>) in
			switch result {
				case .success(let pkmnData):
					let pkmn = Pokemon(withData: pkmnData)
					self.pokemonList.append(pkmn)

					if batch {
						self.pkmnGroup.leave()
						self.counter -= 1
						if self.counter == 0 {
							self.pkmnGroup.leave() // leave an extra time to account for the enter() on populatePokedex
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
	func populatePokedex(entriesLimit limit: Int, offset: Int){
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
	
	/// Fetches and decodes JSON data from a given urlString, returning a Swift5 Result object
	fileprivate func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> ()) {
		
		guard let url = URL(string: urlString) else { return }
		URLSession.shared.dataTask(with: url) { (data, resp, err) in
			if let err = err {
				completion(.failure(err))
				return
			}
			do {
				let decodedData = try JSONDecoder().decode(T.self, from: data!)
				completion(.success(decodedData))
			} catch let jsonError {
				completion(.failure(jsonError))
			}
		}.resume()
	}
}
