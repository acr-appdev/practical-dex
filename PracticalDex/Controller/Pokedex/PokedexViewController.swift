//
//  PokedexViewController.swift
//  PracticalDex
//
//  Created by Allan Rosa on 13/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class PokedexViewController: UICollectionViewController {
	
	private var selectedPokemon = Pokemon()
	private var pokedexManager = PokedexManager()
	private var searchController = UISearchController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		pokedexManager.delegate = self
		
		if let settingsNavVC = tabBarController?.viewControllers![1] as? UINavigationController {
			if let settingsVC = settingsNavVC.topViewController as? SettingsViewController {
				settingsVC.settingsDelegate = self
			}
		}

		
		pokedexManager.populatePokedex(fromNumber: 0, toNumber: 30)
		//pokedexManager.populatePokedex(entriesLimit: 151, offset: 0)
		//pokedexManager.populatePokedex(entriesLimit: 800, offset: 0)
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		collectionView.reloadData() // Updates cells to reflect changes done in settings
	}
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! DetailViewController
		collectionView.reloadData()
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
		
		if let pokedexCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.App.View.Cell.pokedex, for: indexPath) as? PokedexCell {

			pokedexCell.configure(with: pokedexManager.pokemonList[indexPath.row])
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

// MARK: -- PROTOCOLS --
// MARK: PokedexManagerDelegate
extension PokedexViewController: PokedexManagerDelegate {
	func didFinishPopulatingPokedex(_ pokedexManager: PokedexManager) {
		
		pokedexManager.pkmnGroup.notify(queue: .main, execute: {
			self.pokedexManager.pokemonList.sort(by: {$0.number < $1.number})
			pokedexManager.persist()
			UserDefaults.standard.set(true, forKey: K.App.Defaults.databaseIsPopulated)
			self.collectionView.reloadData()
		})
	}
	
	func didFailWithError(_ error: Error) {
		// handle possible errors
	}
	
	func didRetrievePokemon(_ pokedexManager: PokedexManager, pokemon: Pokemon) {
		// DispatchQueue is used in order to free the main thread while data is fetched, so the app isn't frozen
		DispatchQueue.main.async {
			self.pokedexManager.pokemonList.sort(by: {$0.number < $1.number})
			self.collectionView.reloadData()
		}
	}
}

//MARK: - SettingsDelegate
extension PokedexViewController: SettingsDelegate {	
	func dataNeedsReloading() {
		collectionView.reloadData()
	}
	
	func resetData() {
		pokedexManager.resetData(purgeDatabase: true)
		collectionView.reloadData()
		pokedexManager.populatePokedex(fromNumber: 0, toNumber: 151)
	}
}

//MARK: - SearchBarController & Delegate
extension PokedexViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
	func updateSearchResults(for searchController: UISearchController) {
		let searchString = "<Search>"
		print ("Search for : \(searchString) -> Updating...")
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.dismiss(animated: true, completion: nil)
	}
	
	func setupSearchBar(){
		// SearchBar at the top
		self.searchController = UISearchController(searchResultsController:  nil)
		
		self.searchController.searchResultsUpdater = self
		self.searchController.delegate = self
		self.searchController.searchBar.delegate = self
		
		self.searchController.hidesNavigationBarDuringPresentation = false
		//self.searchController.dimsBackgroundDuringPresentation = true
		self.searchController.obscuresBackgroundDuringPresentation = false
		
		searchController.searchBar.becomeFirstResponder()
		
		self.navigationItem.titleView = searchController.searchBar
	}
}
