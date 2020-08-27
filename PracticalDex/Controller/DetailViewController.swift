//
//  ViewController.swift
//  PracticalDex
//
//  Created by Allan Rosa on 15/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class DetailViewController: PokemonViewController {
	
	@IBOutlet weak var spriteImageView: UIImageView!
	@IBOutlet weak var primaryTypeLabel: UILabel!
	@IBOutlet weak var secondaryTypeLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var generaLabel: UILabel!
	@IBOutlet weak var ability1Label: UILabel!
	@IBOutlet weak var ability2Label: UILabel!
	@IBOutlet weak var ability3Label: UILabel!
	@IBOutlet weak var infoContainerView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configure(with: pokemon)
	}
	
	private func configure(with pokemon: Pokemon){
		
		spriteImageView.image = pokemon.sprites.male
		spriteImageView.layer.borderWidth = 1
		spriteImageView.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
		spriteImageView.layer.cornerRadius = 10
		spriteImageView.clipsToBounds = true
		
		configureTypeLabels(with: pokemon)
		
		nameLabel.text = pokemon.name.capitalized
		nameLabel.roundedEdges()
		numberLabel.text = "#\(String(format: "%03d", pokemon.number))"
		numberLabel.roundedEdges()
		
		configureAbilityLabels(with: pokemon.abilities)
		
		// set generaLabel
		
	}
	
	// MARK: - configureTypeLabels
	private func configureTypeLabels(with pokemon: Pokemon){
		
		primaryTypeLabel.text = "\(pokemon.primaryType.rawValue.capitalized)"
		//primaryTypeLabel.roundedEdges()
		primaryTypeLabel.backgroundColor = colorSelector(for: pokemon.primaryType)
		//		switch the types to set the label background color
		
		if pokemon.secondaryType != nil {
			primaryTypeLabel.roundedEdges(mask: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
			secondaryTypeLabel.roundedEdges(mask: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner])
			secondaryTypeLabel.text = "\(pokemon.secondaryType!.rawValue.capitalized)"
			secondaryTypeLabel.backgroundColor = colorSelector(for: pokemon.secondaryType!)
		} else {
			primaryTypeLabel.roundedEdges(withSize: 20.0)
			secondaryTypeLabel.isHidden = true
			
		}
	}
	
	// MARK: configureAbilityLabels
	private func configureAbilityLabels(with abilities: [Ability]){
		if abilities.count < 3{
			ability2Label.isHidden = true
			ability3Label.isHidden = true
		}
		
		abilities.forEach({ ability in
			switch ability.slot {
				case 1:
					ability1Label.text = ability.name
					ability1Label.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
					ability1Label.roundedEdges()
					ability1Label.layer.borderWidth = 1
					ability1Label.layer.borderColor = CGColor(srgbRed: 0.4, green: 0.12, blue: 0.78, alpha: 1)
					if ability.isHidden {
						ability1Label.font = UIFont.boldSystemFont(ofSize: ability1Label.font.pointSize)
					} else {
						ability1Label.font = UIFont.systemFont(ofSize: ability1Label.font.pointSize)
				}
				
				case 2:
					ability2Label.text = ability.name
					ability2Label.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
					ability2Label.roundedEdges()
					ability2Label.layer.borderWidth = 1
					ability2Label.layer.borderColor = CGColor(srgbRed: 0.4, green: 0.12, blue: 0.78, alpha: 1)
					ability2Label.isHidden = false
					
					if ability.isHidden {
						ability2Label.font = UIFont.boldSystemFont(ofSize: ability2Label.font.pointSize)
					} else {
						ability2Label.font = UIFont.systemFont(ofSize: ability2Label.font.pointSize)
				}
				
				case 3:
					ability3Label.text = ability.name
					ability3Label.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
					ability3Label.roundedEdges()
					ability3Label.layer.borderWidth = 1
					ability3Label.layer.borderColor = CGColor(srgbRed: 0.4, green: 0.12, blue: 0.78, alpha: 1)
					ability3Label.isHidden = false
					
					if ability.isHidden {
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


