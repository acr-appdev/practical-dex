//
//  InfoPageViewController.swift
//  PracticalDex
//
//  Created by Allan Rosa on 19/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class InfoPageViewController: UIPageViewController {
	
	var currentIndex: Int = 0
	var pokemon: Pokemon = Pokemon()
	lazy var viewControllerList: [PokemonViewController] = {
		
		let aboutVC = storyboard?.instantiateViewController(withIdentifier: K.App.View.aboutVC) as! AboutViewController
		aboutVC.pokemon = self.pokemon
		let evolutionVC = storyboard?.instantiateViewController(withIdentifier: K.App.View.evolutionVC) as! EvolutionViewController
		evolutionVC.pokemon = self.pokemon
		let movesVC = storyboard?.instantiateViewController(withIdentifier: K.App.View.movesVC) as! MovesViewController
		movesVC.pokemon = self.pokemon
		let statsVC = storyboard?.instantiateViewController(withIdentifier: K.App.View.statsVC) as! StatsViewController
		statsVC.pokemon = self.pokemon
		
		return [aboutVC, evolutionVC, statsVC] // removed moves vc bc not in first version
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		self.dataSource = self
		
		guard let controllersFirst = viewControllerList.first else { return }
		
		setViewControllers([controllersFirst], direction: .forward, animated: true, completion: nil)
		
		// Do any additional setup after loading the view.
	}
}


//MARK: - UIPageViewControllerDataSource
extension InfoPageViewController: UIPageViewControllerDataSource {
	
	func pageViewController(_ pageViewController: UIPageViewController,
							viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		guard let vcIndex = viewControllerList.firstIndex(of: viewController as! PokemonViewController) else { return nil }
		
		let previousIndex = vcIndex - 1
		
		guard previousIndex >= 0 else { return nil }
		guard previousIndex < viewControllerList.count else { return nil }
		
		return viewControllerList[previousIndex]
	}
	
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		guard let vcIndex = viewControllerList.firstIndex(of: viewController as! PokemonViewController) else { return nil }
		
		let nextIndex = vcIndex + 1
		
		guard nextIndex > 0 else { return nil }
		guard nextIndex < viewControllerList.count else { return nil }
		
		return viewControllerList[nextIndex]

	}
	
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		return currentIndex
	}
	
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return viewControllerList.count
	}
}
