//
//  PokedexViewController.swift
//  PracticalDex
//
//  Created by Allan Rosa on 13/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class PokedexViewController: UICollectionViewController, PokedexManagerDelegate {
	func didFinishPopulatingPokedex(_ pokedexManager: PokedexManager) {
		pokedexManager.pkmnGroup.notify(queue: .main, execute: {
			self.pokedexManager.pokemonList.sort(by: {$0.number < $1.number})
			pokedexManager.persist()
			UserDefaults.standard.set(true, forKey: K.App.UserDefaults.databaseIsPopulated)
			self.collectionView.reloadData()
		})
	}
	
	func didFailWithError(_ error: Error) {
		// handle possible errors
	}
	
	func didRetrievePokemon(_ pokedexManager: PokedexManager, pokemon: Pokemon) {
		// Using DispatchQueue because the data comes from networking, so the app isn't frozen
		DispatchQueue.main.async {
			self.pokedexManager.pokemonList.sort(by: {$0.number < $1.number})
			self.collectionView.reloadData()
		}
	}
	
	private var selectedPokemon = Pokemon()
	private var pokedexManager = PokedexManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		pokedexManager.delegate = self

		UserDefaults.standard.set(false, forKey: K.App.UserDefaults.databaseIsPopulated)
		
		pokedexManager.populatePokedex(fromNumber: 0, toNumber: 15)
		//pokedexManager.populatePokedex(entriesLimit: 151, offset: 0)
		//pokedexManager.populatePokedex(entriesLimit: 800, offset: 0)
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Register cell classes
		//self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: K.App.View.pokedexCell)
	}
	
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! DetailViewController
		destinationVC.pokemon = selectedPokemon
	}
	
	
	// MARK: UICollectionViewDataSource
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return pokedexManager.pokemonList.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell = UICollectionViewCell()
		
		if let pokedexCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.App.View.Cell.pokedex, for: indexPath) as? PokedexViewCell {
			
			pokedexCell.configure(with: pokedexManager.pokemonList[indexPath.row])
			//pokedexCell.backgroundColor = UIColor(red: 1.0, green: 0.1, blue: 0.1, alpha: 0.5)
			cell = pokedexCell
		}
		return cell
	}
	
	
	// MARK: UICollectionViewDelegate
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let pokemon = pokedexManager.pokemonList[indexPath.row]
		selectedPokemon = pokemon
		
		self.performSegue(withIdentifier: K.App.View.Segue.detailView, sender: self)
	}
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PokedexViewController: UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 24, left: 6, bottom: 6, right: 6)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let numberOfColumns: CGFloat = 2
		let totalWidth = view.frame.width
		let totalOffsetSpace: CGFloat = 32 // in points
		let pokedexCellWidth = (totalWidth - totalOffsetSpace) / numberOfColumns
		
		return CGSize(width: pokedexCellWidth, height: pokedexCellWidth) // gimme a square
	}
	
}
