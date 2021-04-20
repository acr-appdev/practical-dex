//
//  SettingsSection.swift
//  PracticalDex
//
//  Created by Allan Rosa on 15/09/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import Foundation

/// Defines objects related to custom settings sections
protocol SectionType: CustomStringConvertible {
	var containsSwitch: Bool { get } // require that a bool var is implemented with a getter
	var containsSlider: Bool { get }
	// var containsButton
	
	var containsLabel: Bool { get }
}

/// Defines the sections contained in the Settings TableView Controller
enum SettingsSection: Int, CaseIterable, CustomStringConvertible  {
	case GeneralSettings
	case About
	case Credits
	
	var description: String {
		switch self {
			case .GeneralSettings:
				return "General"
			case .About:
				return "About"
			case .Credits:
				return "Credits"
		}
	}
}

//MARK: - Settings Sections components
enum GeneralSettings: Int, CaseIterable, SectionType {
	// Items under the Settings section General
	case resetData
	case backgroundMusic
	case appVolume
	case boxWallpaper
	
	// Strings describing the items
	var description: String {
		switch self {
			case .resetData: return "Reset Data"
			case .backgroundMusic: return "BGM"
			case .appVolume: return "Volume"
			case .boxWallpaper: return "Box Wallpaper"
		}
	}
	
	// Interface elements that items can contain
	var containsSwitch: Bool {
		switch self {
			case .resetData: return true
			default: return false
		}
	}
	
	var containsSlider: Bool {
		switch self {
			case .appVolume: return true
			default: return false
		}
	}
	
	var containsLabel: Bool {
		switch self {
			case .backgroundMusic: return true
			case .boxWallpaper: return true
			default: return false
		}
	}
}

enum AboutOptions: Int, CaseIterable, SectionType {
	// Items under the Settings section About
	case version
	case termsOfUse
	
	// Strings describing the items
	var description: String {
		switch self {
			case .version: return "Version"
			case .termsOfUse: return "Terms of Use"
		}
	}
	
	// Interface elements that items can contain
	var containsSwitch: Bool {
		switch self {
			case .termsOfUse: return false
			case .version: return false
		}
	}
	
	var containsSlider: Bool {
		switch self {
			default: return false
		}
	}
	
	var containsLabel: Bool {
		switch self {
			default: return false
		}
	}
}

enum CreditsOptions: Int, CaseIterable, SectionType {
	case allanRosa
	case ericMatyas
	// case contact
	// case github
	
	var containsSwitch: Bool {
		switch self {
			default: return false
		}
	}
	
	var containsSlider: Bool {
		switch self {
			default: return false
		}
	}
	
	var containsLabel: Bool {
		switch self {
			default: return false
		}
	}
	
	var description: String {
		switch self {
			case .allanRosa: return "Allan C. Rosa - Development"
			case .ericMatyas: return "Eric Matyas - Music"
		//	case .contact: return "allanccrosa@gmail.com"
		//	case .github: return "github.com/allanccrosa"
		}
	}
}
