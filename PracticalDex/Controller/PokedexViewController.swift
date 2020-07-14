//
//  PokedexViewController.swift
//  PracticalDex
//
//  Created by Allan Rosa on 13/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class PokedexViewController: UICollectionViewController {

	private let pokedexData = [Pokemon(name: "Bulbasaur", number: 1),
							   Pokemon(name: "Magmar", number: 126),
							   Pokemon(name: "Ivysaur", number: 2),
							   Pokemon(name: "Venusaur", number: 3),
							   Pokemon(name: "Squirtle", number: 4),
							   Pokemon(name: "Wartortle", number: 5),
							   Pokemon(name: "Blastoise", number: 6),
							   Pokemon(name: "Charmander", number: 7)]
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
		//self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: K.App.View.pokedexCell)
		
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
		return pokedexData.count
    }

	// 
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell = UICollectionViewCell()
		
		if let pokedexCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.App.View.pokedexCell, for: indexPath) as? PokedexViewCell {
			
			pokedexCell.configure(with: pokedexData[indexPath.row])
			//pokedexCell.backgroundColor = UIColor(red: 1.0, green: 0.1, blue: 0.1, alpha: 0.5)
			cell = pokedexCell
			
		}

		return cell
    }

	
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

//MARK: - UICollectionViewDelegateFlowLayout
extension PokedexViewController: UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 24, left: 6, bottom: 6, right: 6)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let numberOfColumns: CGFloat = 3
		let totalWidth = view.frame.width
		let totalOffsetSpace: CGFloat = 32// in points
		let pokedexCellWidth = (totalWidth - totalOffsetSpace) / numberOfColumns
		
		return CGSize(width: pokedexCellWidth, height: pokedexCellWidth) // gimme a square
	}
}
