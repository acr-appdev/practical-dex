//
//  PokemonManager.swift
//  PracticalDex
//
//  Created by Allan Rosa on 11/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import Foundation

protocol PokedexManagerDelegate {
	// The delegate pattern protocol's requirements
	// didUpdateWeather: Who updated the pokedex? What is the updated data?
	func didUpdatePokedex(_ pokedexManager: PokedexManager, pokemon: Pokemon)
	func didFailWithError(error: Error)
}

// Uses PokeAPI (https://pokeapi.co/api/v2)
struct PokedexManager {
	// This lets another class set itself as its delegate
	var delegate: PokedexManagerDelegate?
	
	// Method that returns the API URL for querying
	func createQueryURL(name: String = "") -> String {
		let url = "https://pokeapi.co/api/v2/pokemon/\(name)#"
		return url
	}
	func createQueryURL(limit: Int, offset: Int = 0) -> String{
		let url = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
		return url
	}
	
	func fetchPokemon(name: String){
		let url = createQueryURL(name: name)
		//		 print("Fetching by city name:")
		//		 print(url)
		performRequest(with: url)
	}
	
	
	// Networking: 4 steps
	func performRequest(with urlString: String){
		// Step 1: Create a URL from the urlString if it's not nil
		if let url = URL(string: urlString){
			
			// Step 2: Create a URLSession
			let session = URLSession(configuration: .default)
			
			// Step 3: Assign a task to the URLSession
			let task = session.dataTask(with: url) {data, response, error in
				if error != nil {
					self.delegate?.didFailWithError(error: error!)
					return // return can be used to exit a function
				}
				if let safeData = data{
					let pokemon = self.parseJSON(safeData)
					self.delegate?.didUpdatePokedex(self, pokemon: pokemon!) // because its inside a closure, 'self' is required to specify that its this class'
				}
			} // end of the trailing closure that the dataTask method takes as input
			
			// Step 4: Start the URLSession task
			task.resume() // tasks are created in a suspended state
		}
	}
	
	// Method that decodes the JSON data returned by the OWM's API, returning a WeatherModel object
	func parseJSON(_ pokemonData: Data) -> Pokemon? {
		let decoder = JSONDecoder() // initialize the JSONDecoder object
		do {
			let decodedData = try decoder.decode(PokemonData.self, from: pokemonData)
			let name = decodedData.name
			let number = decodedData.id
			
			let pokemon = Pokemon(name: name, number: number)
			
			return pokemon
			
		} catch {
			// send error to delegate
			//print(error)
			self.delegate?.didFailWithError(error: error)
			return nil
		}
	}
}


