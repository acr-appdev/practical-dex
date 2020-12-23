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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		flavorTextLabel.text = pokemon.species?.flavorTextEntries[selectedLanguage]?.flavorTextDescription
		
		if let genderRate = pokemon.species?.genderRate {
			// print("\(pokemon.name) GenderRate: \(genderRate)")
			genderBar.progress = Float(genderRate)
			genderBar.backgroundColor = .systemPink
			genderBar.progressTintColor = .systemBlue
		}
		else { // genderless
			// print("\(pokemon.name) GenderRate: Genderless")
			genderBar.progress = 0
			genderBar.backgroundColor = .black
		}
		genderBar.layer.cornerRadius = 6
		genderBar.clipsToBounds = true
		genderBar.layer.sublayers![1].cornerRadius = 6
		genderBar.subviews[1].clipsToBounds = true
		
		heightValueLabel.text = generateHeightText(pokemon.height)
		weightValueLabel.text = generateWeightText(pokemon.weight)
		
		// Do any additional setup after loading the view.
	}
	
	// TODO: Extend Measurement Formatter to do some of this
	private func generateHeightText(_ height: Measurement<UnitLength>) -> String {
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
	
	private func generateWeightText(_ weight: Measurement<UnitMass>) -> String {
		let weightInLbs = weight.converted(to: UnitMass.pounds)
		let weight_USFormatted = "\(String(format: "%.2f", weightInLbs.value)) lbs."
		
		let heightInKgs = weight.converted(to: UnitMass.kilograms)
		let weight_imperialFormatted = "\(String(format: "%.2f", heightInKgs.value)) kg"
		
		return "\(weight_USFormatted) (\(weight_imperialFormatted))"
	}
}

// MARK: - Measurement Extension
extension Measurement where UnitType == UnitLength {
	
	// Example format extension
    private static let usFormatted: MeasurementFormatter = {
       let formatter = MeasurementFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.unitStyle = .long
        return formatter
    }()
	
    var usFormatted: String { Measurement.usFormatted.string(from: self) }
}
