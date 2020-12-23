//
//  Utils.swift
//  PracticalDex
//
//  Created by Allan Rosa on 01/09/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit
import RealmSwift

func getDocumentsDirectory() -> URL {
	let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	return paths[0]
}

// MARK: - saveImage
// TODO: Check for folderName param integrity
func saveImage(_ image: UIImage, named filename: String, toFolder folderName: String = "") -> URL? {
	
	guard let pngData = image.pngData() else { return nil }
	var filepath = getDocumentsDirectory()
	
	if folderName != "" {
		let fileManager = FileManager.default
		filepath = filepath.appendingPathComponent(folderName)
		if !fileManager.fileExists(atPath: filepath.path) {
			do {
				try fileManager.createDirectory(at: filepath, withIntermediateDirectories: true, attributes: nil)
				
			} catch {
				print(error.localizedDescription)
				return nil
			}
		}
	}
	
	filepath = filepath.appendingPathComponent("\(filename).png")
	
	try? pngData.write(to: filepath)
	
	return filepath
}

// MARK: - fetchData
/// Fetches and decodes JSON data from a given urlString, returning a Swift5 Result object
func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> ()) {
	
	guard let url = URL(string: urlString) else { return }
	URLSession.shared.dataTask(with: url) { (data, resp, err) in
		if let err = err {
			completion(.failure(err))
			return
		}
		do {
			let decodedData = try JSONDecoder().decode(T.self, from: data!)
			completion(.success(decodedData))
		} catch let jsonError {
			completion(.failure(jsonError))
		}
	}.resume()
}

//MARK: - Utility Functions
func setUserDefaults() {
	let ud = UserDefaults.standard
	ud.set(true, forKey: K.App.Defaults.hasLaunchedBefore)
	
	// Set false so the database is populated automatically
	ud.set(false, forKey: K.App.Defaults.databaseIsPopulated)
	
	// Configure settings's default values
	ud.set(0.1, forKey: K.App.Defaults.appVolume)
	
	ud.set(K.App.bgmList.first, forKey: K.App.Defaults.selectedBGM)
	ud.set(0, forKey: K.App.Defaults.selectedBGMIndex)
	ud.set(K.App.wallpaperList.first, forKey: K.App.Defaults.selectedWallpaper)
	ud.set(0, forKey: K.App.Defaults.selectedWallpaperIndex)
	
	ud.set(Language.en.rawValue, forKey: K.App.Defaults.selectedLanguage)
}

//MARK: - UIView Extension
extension UIView {
	func pin(to view: UIView){
		self.translatesAutoresizingMaskIntoConstraints = false
		self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}
	
	/// Creates a new imageview in the background
	func addBackgroundImageView(usingImageNamed imageName: String, withFrame frame: CGRect = .zero){
		
		// Create a new imageview and configure its properties
		let backgroundImageView = UIImageView(frame: frame)
		
		backgroundImageView.image = UIImage(named: imageName)
		backgroundImageView.contentMode = .scaleToFill
		backgroundImageView.clipsToBounds = true
		
		// Add the newly created imageview to the bottom layer
		self.insertSubview(backgroundImageView, at: 0)
		
		// Programmatically setting the constraints on the newly created view
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
		backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
	}

	func roundCorner(size: CGFloat, topLeft: Bool = true, topRight: Bool = true, bottomLeft: Bool = true, bottomRight: Bool = true) {
		var mask: CACornerMask = []
		
		if topLeft { mask.insert(.layerMinXMinYCorner) }
		if topRight { mask.insert(.layerMaxXMinYCorner)	}
		if bottomLeft { mask.insert(.layerMinXMaxYCorner) }
		if bottomRight { mask.insert(.layerMaxXMaxYCorner) }
		
		self.layer.cornerRadius = size
		self.layer.maskedCorners = mask
	}
}

// MARK: - UILabel Extensions
extension UILabel {
	func roundedEdges(withSize size: CGFloat? = nil, mask: CACornerMask? = nil){
		self.clipsToBounds = true
		layer.cornerRadius = size ?? frame.width*0.15
		if mask != nil { layer.maskedCorners = mask! }
	}
}

extension UIFont {
	func toggleBold(isBold: Bool) -> UIFont {
		if isBold {
			return UIFont.systemFont(ofSize: self.pointSize)
		} else {
			return UIFont.boldSystemFont(ofSize: self.pointSize)
		}
	}
}
