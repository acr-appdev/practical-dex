//
//  Pokemon.swift
//  PracticalDex
//
//  Created by Allan Rosa on 11/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

struct Pokemon {
	let name: String
	let number: Int
	let sprites: SpriteImages
//	let type1: Type
//	let type2: Type?
//	let ability1: String
//	let ability2: String?
//	let hiddenAbility: String?
//	let struct Stats {
//		let HP: Int
//		let Atk: Int
//		let Def: Int
//		let SpA: Int
//		let SpD: Int
//		let Spe: Int
//	}
	
	init(withData pkmnData: PokemonData){
		name = pkmnData.name
		number = pkmnData.id
		
		var defaultSprite = #imageLiteral(resourceName: "Missingno.")
		if let imageURL = URL(string: pkmnData.sprites.front_default){
			// TODO: Probably should fire this code from a DispatchQueue Async
			if let imageData = try? Data(contentsOf: imageURL){
				//print("I got this data: \(imageData)")
				defaultSprite = UIImage(data: imageData)!
			}
		}
		sprites = SpriteImages(male: defaultSprite)
	}
}

struct SpriteImages {
	let male: UIImage
	// let female: UIImage
	// let shinyMale: UIImage
	// let shinyFemale: UIImage
	// let male_back: UIImage
	// let female_back: UIImage
	// let shinyMale_back: UIImage
	// let shinyFemale_back: UIImage
}


