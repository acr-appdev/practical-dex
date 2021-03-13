//
//  ViewController.swift
//  PracticalDex
//
//  Created by Allan Rosa on 15/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class DetailViewController: PokemonViewController {
	
	// MARK: Properties
	@IBOutlet weak var spriteImageView: UIImageView!
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var primaryTypeLabel: UILabel!
	@IBOutlet weak var secondaryTypeLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var genusLabel: UILabel!
	@IBOutlet weak var ability1Label: UILabel!
	@IBOutlet weak var ability2Label: UILabel!
	@IBOutlet weak var ability3Label: UILabel!
	@IBOutlet weak var infoContainerView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configure(with: pokemon)
	}
	
	// MARK: Configuration Functions
	private func configure(with pokemon: Pokemon){
		
		// Adding the background image to the pokemon sprite image view
		guard let bgImageName = UserDefaults.standard.string(forKey: K.App.Defaults.selectedWallpaper) else { return }
		backgroundImageView.image = UIImage(named: bgImageName)
		backgroundImageView.layer.borderWidth = 2
		backgroundImageView.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
		backgroundImageView.layer.cornerRadius = 10
		
		// Configuring the pokemon sprite image view
		spriteImageView.image = pokemon.sprites.male
		
		// Configuring type labels
		configureTypeLabels(with: pokemon)
		
		// Configuring the pokemon name and number labels
		nameLabel.text = pokemon.name.capitalized
		nameLabel.roundedEdges()
		numberLabel.text = "#\(String(format: "%03d", pokemon.number))"
		numberLabel.roundedEdges()
		
		// Configuring the ability labels
		configureAbilityLabels(with: pokemon.abilities)
		
		// Configuring the genus label
		genusLabel.text = pokemon.species?.genera[selectedLanguage]?.genusDescription
	}
	
	// MARK: - configureTypeLabels
	private func configureTypeLabels(with pokemon: Pokemon){
		let labelCornerSize:CGFloat = 10
		primaryTypeLabel.text = pokemon.primaryType.description
		primaryTypeLabel.backgroundColor = colorSelector(for: pokemon.primaryType)
	
		primaryTypeLabel.layer.borderWidth = 1
		primaryTypeLabel.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
		// switch the types to set the label background color
		
		if pokemon.secondaryType != nil {
			primaryTypeLabel.roundCorner(size: labelCornerSize, topRight: false, bottomRight: false)
			secondaryTypeLabel.roundCorner(size: labelCornerSize, topLeft: false, bottomLeft: false)
			secondaryTypeLabel.text = pokemon.secondaryType!.description
			secondaryTypeLabel.backgroundColor = colorSelector(for: pokemon.secondaryType!)
			
			secondaryTypeLabel.layer.borderWidth = 1
			secondaryTypeLabel.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
		} else {
			primaryTypeLabel.roundedEdges(withSize: labelCornerSize)
			secondaryTypeLabel.isHidden = true
		}
	}
	
	// MARK: configureAbilityLabels
	private func configureAbilityLabels(with abilities: [Int : Ability]){
		let bgColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
		let borderColor = CGColor(red: 0.4, green: 0.12, blue: 0.78, alpha: 0)
		ability2Label.isHidden = true
		ability3Label.isHidden = true
		
		abilities.forEach({ (key, ability) in
			switch ability.slot {
				case 1:
					ability1Label.text = ability.name
					ability1Label.backgroundColor = bgColor
					ability1Label.roundedEdges()
					ability1Label.layer.borderWidth = 1
					ability1Label.layer.borderColor = borderColor
					
					if ability.isHidden {
						print("Ability 1 is hidden")
						ability1Label.font = UIFont.boldSystemFont(ofSize: ability1Label.font.pointSize)
					} else {
						ability1Label.font = UIFont.systemFont(ofSize: ability1Label.font.pointSize)
				}
				
				case 2:
					ability2Label.text = ability.name
					ability2Label.backgroundColor = bgColor
					ability2Label.roundedEdges()
					ability2Label.layer.borderWidth = 1
					ability2Label.layer.borderColor = borderColor
					ability2Label.isHidden = false
					
					if ability.isHidden {
						print("Ability 2 is hidden")
						ability2Label.font = UIFont.boldSystemFont(ofSize: ability2Label.font.pointSize)
					} else {
						ability2Label.font = UIFont.systemFont(ofSize: ability2Label.font.pointSize)
				}
				
				case 3:
					ability3Label.text = ability.name
					ability3Label.backgroundColor = bgColor
					ability3Label.roundedEdges()
					ability3Label.layer.borderWidth = 1
					ability3Label.layer.borderColor = borderColor
					ability3Label.isHidden = false
					
					if ability.isHidden {
						print("Ability 3 is hidden")
						ability3Label.font = UIFont.boldSystemFont(ofSize: ability3Label.font.pointSize)
					} else {
						ability3Label.font = UIFont.systemFont(ofSize: ability3Label.font.pointSize)
				}
				
				default:
					print("Error Setting up AbilityLabels")
			}
		})
	}
	
	
	// MARK: - IBActions
	@IBAction func backButtonPressed(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
			case K.App.View.Segue.infoPageView:
				let destinationVC = segue.destination as! InfoPageViewController
				destinationVC.pokemon = pokemon
			default:
				break
		}
		
		
		// pass the selected cell pokemon
		
		//print("I passed \(selectedPokemon.name.capitalized)")
	}
}


