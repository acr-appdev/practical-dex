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
		let urlString = "https://pokeapi.co/api/v2/pokemon/\(name)"
		
		fetchGenericData(urlString: urlString){ (result: Result<PokemonData, Error>) in
			switch result {
				case .success(let pkmnData):
					let pkmn = Pokemon(withData: pkmnData)
					self.delegate?.didRetrievePokemon(self, pokemon: pkmn)
				//pokemonEntries.forEach( {(pkmn) in print(pkmn.name)} )
				case .failure(let error):
					print("Failed to fetch pokemon by name (\(name)): ", error)
					self.delegate?.didFailWithError(error)
			}
		}
	}
	
	func fetchSpecies(byNumber id: Int){
		let urlString = "https://pokeapi.co/api/v2/pokemon-species/\(id)"
		
		fetchGenericData(urlString: urlString){ (result: Result<PokemonSpeciesData, Error>) in
			switch result {
				case .success(let pkmnData):
					let species = PokemonSpecies(withData: pkmnData)
					
				//pokemonEntries.forEach( {(pkmn) in print(pkmn.name)} )
				case .failure(let error):
					print("Failed to fetch pokemon by number (\(id)): ", error)
					self.delegate?.didFailWithError(error)
			}
		}
	}
	
	func populatePokedex(entriesLimit limit: Int, offset: Int){
		let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
		
		fetchGenericData(urlString: urlString){ (result: Result<MultiplePokemonData, Error>) in
			switch result {
				case .success(let data):
					data.results.forEach({ pkmn in
						self.fetchPokemon(byName: pkmn.name)
					})
				case .failure(let error):
					print("Failed to populate pokedex using limit=\(limit)&offset=\(offset) ", error)
					self.delegate?.didFailWithError(error)
			}
		}
	}
	
	fileprivate func fetchGenericData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> ()) {
		
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
