//
//  PokedexViewController.swift
//  PracticalDex
//
//  Created by Allan Rosa on 13/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {
	
	private var selectedPokemon = Pokemon()
	private var pokedexManager = PokedexManager()
	private var searchController = UISearchController(searchResultsController: nil)
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		pokedexManager.delegate = self
		collectionView.delegate = self
		collectionView.dataSource = self
		
		setupSearchBar()
		
		if let settingsNavVC = tabBarController?.viewControllers![1] as? UINavigationController {
			if let settingsVC = settingsNavVC.topViewController as? SettingsViewController {
				settingsVC.settingsDelegate = self
			}
		}
				
		//pokedexManager.populatePokedex(fromNumber: 0, toNumber: 1)
		//pokedexManager.populatePokedex(fromNumber: 0, toNumber: 12)
		//pokedexManager.populatePokedex(fromNumber: 0, toNumber: 31)
		//pokedexManager.populatePokedex(fromNumber: 0, toNumber: 151)
		pokedexManager.populatePokedex()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupSearchBarTextField()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		collectionView.reloadData() // Updates cells to reflect changes done in settings
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! DetailViewController
		collectionView.reloadData()
		destinationVC.pokemon = selectedPokemon
	}
	
	fileprivate func setupSearchBar(){
		searchController.obscuresBackgroundDuringPresentation = true
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		
		searchController.searchBar.searchTextField.backgroundColor = K.Design.Color.blue
		searchController.searchBar.searchTextField.textColor = K.Design.Color.white
		searchController.searchBar.searchTextField.tintColor = K.Design.Color.red
		searchController.searchBar.tintColor = K.Design.Color.red // cancel search button tint color
		searchController.searchBar.placeholder = "Search Pokémon..."
		
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}
	
	fileprivate func setupSearchBarTextField(){
		searchController.searchBar.textField?.textColor = K.Design.Color.white
		searchController.searchBar.changePlaceholderTextColor(to: K.Design.Color.white ?? .white)
	}
}

// MARK: - PokedexManagerDelegate
extension PokedexViewController: PokedexManagerDelegate {
	func didFinishFetchingSpecies(_ pokedexManager: PokedexManager) {
		pokedexManager.updateFetchStatus(of: .Species)
		pokedexManager.spcsGroup.notify(queue: .main, execute: {
			self.pokedexManager.persist(speciesList: true)
		})
	}
	
	func didFinishFetchingPokemon(_ pokedexManager: PokedexManager) {
		pokedexManager.updateFetchStatus(of: .Pokemon)
		pokedexManager.pkmnGroup.notify(queue: .main, execute: {
			pokedexManager.persist(pokemonList: true)
			self.collectionView.reloadData()
		})
	}
	
	func didFailWithError(_ error: Error) {
		// handle possible errors - e.g. present popups with infos regarding error and possible solutions
		// internet connection error
	}
	
	// Used to update the pokedex as each entry is added
	func didUpdatePokedexData(_ pokedexManager: PokedexManager) {
		// DispatchQueue is used in order to free the main thread while data is fetched, so the app isn't frozen
		DispatchQueue.main.async {
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
		pokedexManager.populatePokedex()
	}
}

// MARK: - UICollectionViewDelegate
extension PokedexViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let number = pokedexManager.pokemonKeys[indexPath.row]
		let pokemon = pokedexManager.pokemonList[number]

		selectedPokemon = pokemon ?? Pokemon()
		print("Clicked on indexPath: \(indexPath.row) \n Performing segue with \(selectedPokemon.number): \(selectedPokemon.name)")
		
		self.performSegue(withIdentifier: K.App.View.Segue.detailView, sender: self)
	}
}

//MARK: - UICollectionViewDataSource
extension PokedexViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell = UICollectionViewCell()
		if let pokedexCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.App.View.Cell.pokedex, for: indexPath) as? PokedexCell {
			
			let number = pokedexManager.pokemonKeys[indexPath.row]
			if let cellPokemon = pokedexManager.pokemonList[number] {
				pokedexCell.configure(with: cellPokemon)
			}
			cell = pokedexCell
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return pokedexManager.pokemonKeys.count
	}
}

//MARK: - CollectionViewDelegateFlowLayout
extension PokedexViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 24, left: 6, bottom: 6, right: 6)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let numberOfColumns: CGFloat = 2
		let totalWidth = view.frame.width
		let totalOffsetSpace: CGFloat = 18 // in points (min for 2 columns = 12)
		let pokedexCellWidth = (totalWidth - totalOffsetSpace) / numberOfColumns
		
		return CGSize(width: pokedexCellWidth, height: pokedexCellWidth) // make the cell a square
	}
}

//MARK: - SearchBarDelegate
extension PokedexViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if (!(searchBar.text?.isEmpty)!) {
			//print("Search for: \(searchBar.text!)")
			pokedexManager.filter(searchBar.text!)
		}
		else {
			pokedexManager.restorePokemonList()
		}
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		pokedexManager.restorePokemonList()
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if (!(searchBar.text?.isEmpty)!) {
			//print("Search for: \(searchBar.text!)")
			pokedexManager.filter(searchBar.text!)
		}
		else {
			pokedexManager.restorePokemonList()
		}
	}
}

// MARK: - UISearchResultsUpdating
extension PokedexViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		// TODO
	}
}
