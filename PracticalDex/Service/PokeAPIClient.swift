//
//  File.swift
//  PracticalDex
//
//  Created by Allan Rosa on 14/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

protocol PokeAPIClientDelegate {
	// The delegate pattern protocol's requirements
	// didUpdatePokedex: Who updated the pokedex? What is the updated data?
	mutating func didUpdatePokedex(_ pokeAPIClient: PokeAPIClientDelegate, pkmnEntries: [Pokemon])
	func didFailWithError(error: Error)
}

// Uses PokeAPI (https://pokeapi.co/api/v2)
struct PokeAPIClient {
	var delegate: PokeAPIClientDelegate?
	
//	func fetchPokemon(name: String){
//		let url = createQueryURL(name: name)
//		print(url)
//		performRequest(with: url)
//	}
	
//	func populatePokedex(limit: Int, offset: Int){
//		let url = createQueryURL(limit: limit, offset: offset)
//		performRequest(with: url)
//	}
	
	// MARK: createQueryURL
	func createQueryURL(name: String = "") -> URL? {
		let urlString = "https://pokeapi.co/api/v2/pokemon/\(name)"
		let url = URL(string: urlString)
		return url
	}
	
//	fileprivate func createQueryURL(limit: Int, offset: Int = 0) -> String{
//		let url = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
//		return url
//	}
	
	// MARK: performRequest
	// Networking: 4 steps
//	func performRequest(with urlString: String){
//		// Step 1: Create a URL from the urlString if it's not nil
//		if let url = URL(string: urlString){
//
//			// Step 2: Create a URLSession
//			let session = URLSession(configuration: .default)
//
//			// Step 3: Assign a task to the URLSession
//			let task = session.dataTask(with: url) {data, response, error in
//				if error != nil {
//					self.delegate?.didFailWithError(error: error!)
//					return // return can be used to exit a function
//				}
//
//				if let safeData = data{
//					// Successfully retrieved data, parse it
//					let pokemonEntries = self.parseJSON(safeData)
//					// Inform the delegate the data is ready to be used
//					//self.delegate?.didUpdatePokedex(self, pkmnEntries: <#T##[Pokemon]#>)
//
//				}
//			} // end of the trailing closure that the dataTask method takes as input
//
//			// Step 4: Start the URLSession task
//			task.resume() // tasks are created in a suspended state
//		}
//	}
	
	// Method that decodes the JSON data returned by PokeAPI
//	fileprivate func parseJSON(_ pokemonData: Data) -> Pokemon? {
//		let decoder = JSONDecoder() // initialize the JSONDecoder object
//		do {
//			let decodedData = try decoder.decode(PokemonData.self, from: pokemonData)
//
//			// Translate the decoded JSON data to fill our Model attributes
//			let name = decodedData.name
//			let number = decodedData.id
//
//			var defaultSprite = UIImage()
//
//			if let imageURL = URL(string: decodedData.sprites.front_default){
//				print(imageURL)
//				if let imageData = try? Data(contentsOf: imageURL){
//					print("I got this data: \(imageData)")
//					defaultSprite = UIImage(data: imageData, scale: 10)!
//				} else {
//					defaultSprite = #imageLiteral(resourceName: "Missingno.")
//					print("Elsed zzz")
//				}
//			}
//			let sprites = SpriteImages(normal: defaultSprite)
//			// Finally, return the new object
//			let pokemon = Pokemon(name: name, number: number, sprites: sprites)
//
//			return pokemon
//
//		} catch {
//			// Inform the delegate the call failed
//			self.delegate?.didFailWithError(error: error)
//			return nil
//		}
//	}
	
	
	func fetchPokemonDataJSON(byPokemonName name: String, completion: @escaping (Result<[Pokemon], Error>) -> ()) {
		
		guard let url = createQueryURL(name: name) else { return }
		
		URLSession.shared.dataTask(with: url) { (data, resp, err) in
			
			if let err = err {
				completion(.failure(err))
				return
			}
			
			// successful
			do {
				var pkmnEntries: [Pokemon] = []
				
				let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data!
				)
				
				let pkmn = Pokemon(data: pokemonData)
				pkmnEntries.append(pkmn)
				completion(.success(pkmnEntries))
				//                completion(pkmnEntries, nil)
				
			} catch let jsonError {
				completion(.failure(jsonError))
				//                completion(nil, jsonError)
			}
		}.resume() // URLSessions are created in a suspended state, this lets we resume (start) them
	}
	
}
