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
	
	func didFailWithError(error: Error)
}

// Manages Pokedex entries and handles calls to PokeAPI (https://pokeapi.co/api/v2)
struct PokedexManager {
	
	var delegate: PokedexManagerDelegate?
	
	func fetchPokemon(byName name: String){
		fetchPokemonDataJSON(byName: name) { (result) in
			switch result {
				case .success(let pokemonEntries):
					self.delegate?.didRetrievePokemon(self, pokemon: pokemonEntries[0])
					//pokemonEntries.forEach( {(pkmn) in print(pkmn.name)} )
				case .failure(let error):
					print("Failed to fetch pokemon by name (\(name)): ", error)
			}
		}
	}
	
	fileprivate func fetchPokemonDataJSON(byName name: String, completion: @escaping (Result<[Pokemon], Error>) -> ()) {
		
		guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)") else { return }
		
		URLSession.shared.dataTask(with: url) { (data, resp, err) in
			
			if let err = err {
				completion(.failure(err))
				return
			}
			
			// Successfully retrieved data
			do {
				let pokemonDecodedData = try JSONDecoder().decode(PokemonData.self, from: data!)
				var pkmnEntries: [Pokemon] = []
				//pokemonDecodedData.forEach({pkmnData in
				//	let newEntry = Pokemon(withData: pkmnData)
				//	pkmnEntries.append(newEntry)
				// })
				let pkmn = Pokemon(withData: pokemonDecodedData)
				pkmnEntries.append(pkmn)
				completion(.success(pkmnEntries))
				
			} catch let jsonError {
				completion(.failure(jsonError))
			}
		}.resume()
	}
}
