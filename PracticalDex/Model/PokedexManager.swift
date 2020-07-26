//
//  PokemonManager.swift
//  PracticalDex
//
//  Created by Allan Rosa on 11/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

protocol PokedexManagerDelegate {
	// The delegate pattern protocol's requirements
	// didRetrievePokemon: Who updated the pokedex? What is the updated data?
	func didRetrievePokemon(_ pokedexManager: PokedexManager, pokemon: Pokemon)
	func didFailWithError(_ error: Error)
}

// Manages Pokedex entries and handles calls to PokeAPI (https://pokeapi.co/api/v2)
struct PokedexManager {
	
	var delegate: PokedexManagerDelegate?
	
	func fetchPokemon(byName name: String){
		fetchPokemonDataJSON(byName: name) { (result) in
			switch result {
				case .success(let pkmn):
					self.delegate?.didRetrievePokemon(self, pokemon: pkmn)
				//pokemonEntries.forEach( {(pkmn) in print(pkmn.name)} )
				case .failure(let error):
					print("Failed to fetch pokemon by name (\(name)): ", error)
					self.delegate?.didFailWithError(error)
			}
		}
	}
	
	fileprivate func fetchPokemonDataJSON(byName name: String, completion: @escaping (Result<Pokemon, Error>) -> ()) {
		
		guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)") else { return }
		
		URLSession.shared.dataTask(with: url) { (data, resp, err) in
			
			if let err = err {
				completion(.failure(err))
				return
			}
			// Successfully retrieved data
			do {
				let pokemonDecodedData = try JSONDecoder().decode(PokemonData.self, from: data!)
				//pokemonDecodedData.forEach({pkmnData in
				//	let newEntry = Pokemon(withData: pkmnData)
				//	pkmnEntries.append(newEntry)
				// })
				let pkmn = Pokemon(withData: pokemonDecodedData)
				completion(.success(pkmn))
				
			} catch let jsonError {
				completion(.failure(jsonError))
			}
		}.resume()
	}
	
	func populatePokedex(entriesLimit limit: Int, offset: Int){
		fetchPokemonDataJSON(limit: limit, offset: offset){ (result) in
			switch result {
				case .success(let pkmnResources):
					pkmnResources.forEach({ pkmn in
						self.fetchPokemon(byName: pkmn.name)
					})
				//pokemonEntries.forEach( {(pkmn) in print(pkmn.name)} )
				case .failure(let error):
					print("Failed to populate pokedex using limit=\(limit)&offset=\(offset) ", error)
					self.delegate?.didFailWithError(error)
			}
		}
	}
	
	fileprivate func fetchPokemonDataJSON(limit: Int, offset: Int, completion: @escaping (Result<[NamedAPIResource], Error>) -> ()) {
		
		guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else { return }
		
		URLSession.shared.dataTask(with: url) { (data, resp, err) in
			
			if let err = err {
				completion(.failure(err))
				return
			}
			// Successfully retrieved data
			do {
				let pokemonResourcesData = try JSONDecoder().decode(MultiplePokemonData.self, from: data!)

				completion(.success(pokemonResourcesData.results))
				
			} catch let jsonError {
				completion(.failure(jsonError))
			}
		}.resume()
	}
}
