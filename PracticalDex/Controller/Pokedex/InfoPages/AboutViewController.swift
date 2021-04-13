//
//  AboutViewController.swift
//  PracticalDex
//
//  Created by Allan Rosa on 22/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class AboutViewController: PokemonViewController {
	
	@IBOutlet weak var flavorTextLabel: UILabel!
	@IBOutlet weak var genderRateBar: UIProgressView!
	@IBOutlet weak var heightValueLabel: UILabel!
	@IBOutlet weak var weightValueLabel: UILabel!
	@IBOutlet weak var genderBar: UIProgressView!
	@IBOutlet weak var flyingGroupLabel: UILabel!
	@IBOutlet weak var eggGroupValueLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		setupInfoLabels()
		
		// Do any additional setup after loading the view.
	}
	
	fileprivate func setupInfoLabels(){
		// Set up the flavor Text
		flavorTextLabel.text = pokemon.species?.flavorTextEntries[selectedLanguage]?.flavorTextDescription
		
		// Set up the gender ratio
		if let genderRate = pokemon.species?.genderRate {
			genderBar.progress = Float(genderRate)
			genderBar.backgroundColor = .systemPink
			genderBar.progressTintColor = .systemBlue
		}
		else { // genderless
			genderBar.progress = 0
			genderBar.backgroundColor = .black
		}
		genderBar.layer.cornerRadius = 6
		genderBar.clipsToBounds = true
		genderBar.layer.sublayers![1].cornerRadius = 6
		genderBar.subviews[1].clipsToBounds = true
		
		// Set up height and weight values
		heightValueLabel.text = generateHeightText(pokemon.height)
		weightValueLabel.text = generateWeightText(pokemon.weight)
		
		// Set up the egg groups
		var eggGroupsText = ""
		
		pokemon.species?.eggGroups.forEach({ (eggGroup) in
			if eggGroupsText == "" {
				eggGroupsText = eggGroup.description
			} else {
				eggGroupsText.append(" / ")
				eggGroupsText.append(eggGroup.description)
			}
		})
		eggGroupValueLabel.text = eggGroupsText.capitalized

	}
	
	// TODO: Extend Measurement Formatter to do some of this
	fileprivate func generateHeightText(_ height: Measurement<UnitLength>) -> String {
		// format the height in feet from 123.456 ft to 12'34" (12 ft 34 in)
		let heightInFeet = height.converted(to: UnitLength.feet)
		let feetIntegerPart = Int(floor(heightInFeet.value))
		let feetDecimalPart: Measurement<UnitLength> = .init(value: heightInFeet.value.truncatingRemainder(dividingBy: 1), unit: .feet)
		let feetDecimalPartInInches = Int(feetDecimalPart.converted(to: .inches).value.rounded(.up))
		
		let height_USFormatted = "\(feetIntegerPart)'\(feetDecimalPartInInches)\""
		
		let heightInMeters = height.converted(to: UnitLength.meters)
		let height_imperialFormatted = "\(String(format: "%.2f", heightInMeters.value)) m"

		return "\(height_USFormatted) (\(height_imperialFormatted))"
	}
	
	fileprivate func generateWeightText(_ weight: Measurement<UnitMass>) -> String {
		let weightInLbs = weight.converted(to: UnitMass.pounds)
		let weight_USFormatted = "\(String(format: "%.2f", weightInLbs.value)) lbs."
		
		let heightInKgs = weight.converted(to: UnitMass.kilograms)
		let weight_imperialFormatted = "\(String(format: "%.2f", heightInKgs.value)) kg"
		
		return "\(weight_USFormatted) (\(weight_imperialFormatted))"
	}
}

//MARK: - UIScrollViewDelegate
extension AboutViewController: UIScrollViewDelegate{
	
}

