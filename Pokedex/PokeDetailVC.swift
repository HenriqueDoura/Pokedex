//
//  PokeDetailVC.swift
//  Pokedex
//
//  Created by Henrique Dourado on 21/05/16.
//  Copyright © 2016 Henrique Dourado. All rights reserved.
//

import UIKit

class PokeDetailVC: UIViewController {

    @IBOutlet weak var pokeName: UILabel!
    @IBOutlet weak var pokeImg: UIImageView!
    @IBOutlet weak var pokeDesc: UILabel!
    @IBOutlet weak var pokeType: UILabel!
    @IBOutlet weak var pokeDefense: UILabel!
    @IBOutlet weak var pokeHeight: UILabel!
    @IBOutlet weak var pokeWeight: UILabel!
    @IBOutlet weak var pokeBaseAttack: UILabel!
    @IBOutlet weak var nextEvo: UILabel!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var nextEvoEvoImg: UIImageView!
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            pokeName.text = pokemon.name.capitalizedString
            pokeImg.image = UIImage(named: "\(pokemon.pokedexId)")
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
}
