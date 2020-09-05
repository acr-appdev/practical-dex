//
//  Utils.swift
//  PracticalDex
//
//  Created by Allan Rosa on 01/09/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

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
