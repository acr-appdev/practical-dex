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
	let primaryType: Type
	let secondaryType: Type?
	let abilities: [AbilityAttribute]
	//	let struct Stats {
	//		let HP: Int
	//		let Atk: Int
	//		let Def: Int
	//		let SpA: Int
	//		let SpD: Int
	//		let Spe: Int
	//	}
	init(name: String , number: Int, sprites: SpriteImages, primaryType: Type, secondaryType: Type?, abilities: [AbilityAttribute]){
		self.name = name
		self.number = number
		self.sprites = sprites
		self.primaryType = primaryType
		self.secondaryType = secondaryType
		self.abilities = abilities
	}
	
	init(){
		self.name = "Missingno"
		self.number = 0
		self.sprites = SpriteImages(male: #imageLiteral(resourceName: "Missingno."))
		self.primaryType = .None
		self.secondaryType = nil
		self.abilities = [AbilityAttribute(ability: AbilityData(name: "No_data1"), is_hidden: false, slot: 1),
						  AbilityAttribute(ability: AbilityData(name: "No_data2"), is_hidden: false, slot: 2),
						  AbilityAttribute(ability: AbilityData(name: "No_data3"), is_hidden: true, slot: 3)]
		//self.stats
	}
	
	init(withData pkmnData: PokemonData){
		self.name = pkmnData.name
		self.number = pkmnData.id
		
		var defaultSprite = #imageLiteral(resourceName: "Missingno.")
		if let imageURL = URL(string: pkmnData.sprites.front_default){
			// TODO: Probably should fire this code from a DispatchQueue Async
			if let imageData = try? Data(contentsOf: imageURL){
				//print("I got this data: \(imageData)")
				defaultSprite = UIImage(data: imageData)!
			}
		}
		self.sprites = SpriteImages(male: defaultSprite)
		
		self.primaryType = typeSelector(pkmnData.types[0])
		if pkmnData.types.count > 1 {
			self.secondaryType = typeSelector(pkmnData.types[1])
		} else {
			self.secondaryType = nil
		}
		
		self.abilities = pkmnData.abilities
		
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

private func typeSelector(_ input: TypeData) -> Type{
	let returnType: Type
	switch input.type.name.lowercased() {
		case "bug" :
			returnType = Type.Bug
		case "dark" :
			returnType = Type.Dark
		case "dragon" :
			returnType = Type.Dragon
		case "electric" :
			returnType = Type.Electric
		case "fairy" :
			returnType = Type.Fairy
		case "fighting" :
			returnType = Type.Fighting
		case "fire" :
			returnType = Type.Fire
		case "flying" :
			returnType = Type.Flying
		case "ghost" :
			returnType = Type.Ghost
		case "grass" :
			returnType = Type.Grass
		case "ground" :
			returnType = Type.Ground
		case "ice" :
			returnType = Type.Ice
		case "normal" :
			returnType = Type.Normal
		case "poison" :
			returnType = Type.Poison
		case "psychic" :
			returnType = Type.Psychic
		case "rock":
			returnType = Type.Rock
		case "steel" :
			returnType = Type.Steel
		case "water":
			returnType = Type.Water
		default:
			returnType = Type.None
	}
	
	return returnType
}
