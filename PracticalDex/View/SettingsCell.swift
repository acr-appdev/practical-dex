//
//  SettingsCell.swift
//  PracticalDex
//
//  Created by Allan Rosa on 11/09/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

protocol SettingsCellDelegate {
	func didToggleSwitch(_ sender: UISwitch)
}

class SettingsCell: UITableViewCell {
	
	// MARK: - Properties
	var delegate: SettingsCellDelegate?
	
	var sectionType: SectionType? {
		didSet {
			guard let sectionType = sectionType else { return }
			textLabel?.text = sectionType.description
			switchControl.isHidden = !sectionType.containsSwitch
			sliderControl.isHidden = !sectionType.containsSlider
			labelControl.isHidden = !sectionType.containsLabel
		}
	}
	
	lazy var switchControl: UISwitch = {
		let switchControl = UISwitch()
		switchControl.isOn = true
		switchControl.onTintColor = UIColor(red: 65/255, green: 120/255, blue: 250/255, alpha: 1)
		switchControl.translatesAutoresizingMaskIntoConstraints = false
		switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
		
		return switchControl
	}()
	
	lazy var sliderControl: CustomSlider = {
		let sliderControl = CustomSlider(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 20)))
		sliderControl.minimumValue = 0
		sliderControl.maximumValue = 1
		sliderControl.value = sliderControl.maximumValue
		sliderControl.isContinuous = true
		sliderControl.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
		
		sliderControl.translatesAutoresizingMaskIntoConstraints = false
		return sliderControl
	}()
	
	lazy var labelControl: UILabel = {
		let labelControl = UILabel()
		labelControl.numberOfLines = 1
		labelControl.lineBreakMode = .byTruncatingTail
		labelControl.text = ""
		labelControl.textAlignment = .right
		labelControl.textColor	 = K.Design.Color.menuLightBlue
		
		labelControl.translatesAutoresizingMaskIntoConstraints = false
		return labelControl
	}()
	
	// MARK: - Init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		// Configure the switch
		self.contentView.addSubview(switchControl)
		switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
		
		// Configure the slider
		self.contentView.addSubview(sliderControl)
		sliderControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
		sliderControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		sliderControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
		
		// Configure the label
		self.contentView.addSubview(labelControl)
		//labelControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
		labelControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
		labelControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Selectors
	@objc func handleSwitchAction(sender: UISwitch){
		delegate?.didToggleSwitch(sender)
	}
	
	@objc func sliderValueDidChange(sender: UISlider){
		switch sliderControl.tag {
			case GeneralSettings.appVolume.rawValue:
				UserDefaults.standard.set(sender.value, forKey: K.App.Defaults.appVolume)
				bgmPlayer?.setVolume(UserDefaults.standard.value(forKey: K.App.Defaults.appVolume) as! Float, fadeDuration: 0)
			default:
				print("sliderValueDidChange: Tag \(sender.tag) defaulted")
		}
	}
}
