//
//  SecondViewController.swift
//  PracticalDex
//
//  Created by Allan Rosa on 10/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

protocol SettingsDelegate {
	func dataNeedsReloading()
	func resetData()
}

class SettingsViewController: UIViewController, SettingsCellDelegate {
	// MARK: - Properties
	var tableView: UITableView!
	var settingsDelegate: SettingsDelegate?
	let defaults = UserDefaults.standard
	
	// MARK: - Init
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureUI()
	}
	
	// MARK: --Helper Functions--
	func configureUI(){
		configureTableView()
				
		navigationController?.modalPresentationStyle = .fullScreen
		navigationController?.modalTransitionStyle = .partialCurl
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.barStyle = .black
		navigationController?.navigationBar.backgroundColor = K.Design.Color.blue
		navigationController?.navigationBar.tintColor = K.Design.Color.white
		
		navigationItem.title = "Settings"
	}
	
	func configureTableView() {
		tableView = UITableView()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.rowHeight = 60
		tableView.backgroundColor = K.Design.Color.blue
		tableView.separatorColor = K.Design.Color.white
		tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
		
		tableView.register(SettingsCell.self, forCellReuseIdentifier: K.App.View.Cell.settings)
		view.addSubview(tableView)
		tableView.frame = view.frame
	}
}

//MARK: - --Delegate and DataSource--
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return SettingsSection.allCases.count
	}
	
	// MARK: - numberOfRowsInSection
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let section = SettingsSection(rawValue: section) else { return 0 }
		switch section {
			case .GeneralSettings: // first section
				return GeneralSettings.allCases.count
			case .About: // second section
				return AboutOptions.allCases.count
			case .Developer:
				return DeveloperOptions.allCases.count
		}
	}
	
	// MARK: - viewForHeaderInSection
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = K.Design.Color.darkBlue
		
		let title = UILabel()
		title.font = .boldSystemFont(ofSize: 20)
		title.textColor = K.Design.Color.white
		title.text = SettingsSection(rawValue: section)?.description
		view.addSubview(title)
		
		title.translatesAutoresizingMaskIntoConstraints = false
		title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
		
		return view
	}
	
	// MARK: - markForHeightInSection
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40
	}
	
	// MARK: - cellforRowAt
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.App.View.Cell.settings, for: indexPath) as! SettingsCell
		guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
		
		cell.selectionStyle = .none
		cell.backgroundColor = K.Design.Color.blue
		cell.textLabel?.font = .boldSystemFont(ofSize: (cell.textLabel?.font.pointSize)!)
		cell.textLabel?.textColor = K.Design.Color.white
		
		switch section {
			case .GeneralSettings: // first section
				let generalOptions = GeneralSettings(rawValue: indexPath.row)
				cell.textLabel?.text = generalOptions?.description
				cell.sectionType = generalOptions
				
				// tags are used to identify which cell's accessory received an action in the action handler, implemented in the settingscell class
				cell.switchControl.tag = generalOptions?.rawValue ?? -1
				cell.sliderControl.tag = generalOptions?.rawValue ?? -1
				
				switch generalOptions {
					case .resetData:
						cell.switchControl.onTintColor = K.Design.Color.red
						cell.delegate = self
		
					case .appVolume:
						cell.sliderControl.value = defaults.float(forKey: K.App.Defaults.appVolume)
						cell.sliderControl.tintColor = K.Design.Color.red
						
					case .backgroundMusic:
						cell.labelControl.text = defaults.string(forKey: K.App.Defaults.selectedBGM)
						cell.labelControl.textColor = K.Design.Color.red
						
					case .boxWallpaper:
						cell.labelControl.text = defaults.string(forKey: K.App.Defaults.selectedWallpaper)
						cell.labelControl.textColor = K.Design.Color.red
						
					default:
						break
				}
				
			case .About: // second section
				let aboutOptions = AboutOptions(rawValue: indexPath.row)
				cell.textLabel?.text = aboutOptions?.description
				cell.sectionType = aboutOptions
				
			case .Developer:
				let developerOptions = DeveloperOptions(rawValue: indexPath.row)
				cell.textLabel?.text = developerOptions?.description
				cell.accessoryType = .disclosureIndicator
				cell.sectionType = developerOptions
		}
		
		return cell
	}
	
	// MARK: - didSelectRowAt
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let section = SettingsSection(rawValue: indexPath.section) else { return }
		
		switch  section {
			case .About:
				// Handle stuff when the user clicks any row in this section
				if let sectionSelected = AboutOptions(rawValue: indexPath.row){
					
					switch sectionSelected {
						case .termsOfUse:
							let vc = SettingsDetailViewController()
							vc.title = AboutOptions.termsOfUse.description
							vc.contents = ["Check the terms of use on http://github.com/acr-appdev/practicaldex"]
							navigationController?.pushViewController(vc, animated: true)
							
						case .version:
							let vc = SettingsDetailViewController()
							vc.title = AboutOptions.version.description
							vc.contents = ["Version 1.0", "Change log"]
							navigationController?.pushViewController(vc, animated: true)
					}
				}
				
			case .GeneralSettings:
				// Handle stuff when the user clicks any row in this section
				if let sectionSelected = GeneralSettings(rawValue: indexPath.row){
					
					switch sectionSelected {
						case .backgroundMusic:
							presentBGMView()
							
						case .boxWallpaper:
							presentBoxWallpaperView()
							
						default: break
					}
				}
				
			case .Developer:
				// Handle stuff when the user clicks any row in this section
				let vc = SettingsDetailViewController()
				vc.title = DeveloperOptions.name.description
				vc.contents = ["@acr_appdev", "github.com/acr-appdev"]
				navigationController?.pushViewController(vc, animated: true)
			
			// The default cell shouldn't be clickable
			// default: break
		}
	}
	
	// MARK: -- SettingsCellDelegate --
	func didToggleSwitch(_ sender: UISwitch) {
		
		switch sender.tag {
			// Reset Data
			case 0:
				if !sender.isOn {
					// Create an alert to inform the user about data deletion
					let alert = UIAlertController(title: "Reset Pokédex Data?", message: "You will need an internet connection to download the data again.", preferredStyle: .alert)
					
					alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in

						self.settingsDelegate?.resetData()
						sender.setOn(true, animated: true)
					}))
					
					alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in

						sender.setOn(true, animated: true)
					}))
					
					present(alert, animated: true, completion: nil)
				}
				
			// No other switches implemented
			default: break
		}
	}
	
	// MARK: -- Helper Functions --
	
	func presentBoxWallpaperView() {
		let previousWallpaper = defaults.string(forKey: K.App.Defaults.selectedWallpaper)
		let selectedWallpaperIndex = defaults.integer(forKey: K.App.Defaults.selectedWallpaperIndex)
		
		let vc = GenericPickerViewController()
		vc.title = GeneralSettings.boxWallpaper.description
		vc.items = [K.App.wallpaperList]
		
		// An attribute is used to set the default index because at this point we don't have the pickerView's delegate assigned
		vc.presetRowIndex = selectedWallpaperIndex
		
		// Handle the value the user selected in the pickerView
		vc.completionHandler = { selectedItem, itemIndex in
			self.defaults.setValue(selectedItem, forKey: K.App.Defaults.selectedWallpaper)
			self.defaults.setValue(itemIndex, forKey: K.App.Defaults.selectedWallpaperIndex)
			
			if selectedItem != previousWallpaper {
				self.settingsDelegate?.dataNeedsReloading()
				self.tableView.reloadData()
			}
		}
		// Present our newly created view controller
		navigationController?.pushViewController(vc, animated: true)
	}
	
	// MARK: presentBGMView
	func presentBGMView(){
		let previousBGM = UserDefaults.standard.string(forKey: K.App.Defaults.selectedBGM)
		let selectedBGMIndex = UserDefaults.standard.integer(forKey: K.App.Defaults.selectedBGMIndex)
		
		let vc = GenericPickerViewController()
		vc.title = GeneralSettings.backgroundMusic.description
		vc.items = [K.App.bgmList]
		
		// An attribute is used to set the default index because at this point we don't have the pickerView's delegate assigned
		vc.presetRowIndex = selectedBGMIndex
		
		// Handle the value the user selected in the pickerView
		vc.completionHandler = { selectedItem, itemIndex in
			UserDefaults.standard.setValue(selectedItem, forKey: K.App.Defaults.selectedBGM)
			UserDefaults.standard.setValue(itemIndex, forKey: K.App.Defaults.selectedBGMIndex)
			
			if selectedItem != previousBGM {
				playBGM(sound: selectedItem, type: "mp3")
				self.tableView.reloadData()
			}
		}
		// Present our newly created view controller
		navigationController?.pushViewController(vc, animated: true)
	}
}

//MARK: -- Protocol Default Implementation --
extension SettingsDelegate {
	func resetData() { /* Do nothing */ }
}
