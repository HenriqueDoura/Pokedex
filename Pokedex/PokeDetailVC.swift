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
    @IBOutlet weak var nowEvo: UIImageView!
    @IBOutlet weak var pokeID: UILabel!
    @IBOutlet weak var pokeDesc: UILabel!
    @IBOutlet weak var pokeType: UILabel!
    @IBOutlet weak var pokeDefense: UILabel!
    @IBOutlet weak var pokeHeight: UILabel!
    @IBOutlet weak var pokeWeight: UILabel!
    @IBOutlet weak var pokeBaseAttack: UILabel!
    @IBOutlet weak var nextEvo: UILabel!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            pokeName.text = pokemon.name.capitalizedString
            pokeImg.image = UIImage(named: "\(pokemon.pokedexId)")
        
            pokemon.downloadPokemonDetails {
                self.updateUI()
            }
    }
    
    func updateUI() {
        self.pokeDesc.text = self.pokemon.description
        self.pokeType.text = self.pokemon.type
        self.pokeHeight.text = self.pokemon.height
        self.pokeWeight.text = self.pokemon.weight
        self.pokeDefense.text = self.pokemon.defense
        self.pokeID.text = "\(self.pokemon.pokedexId)"
        self.pokeBaseAttack.text = self.pokemon.attack
        self.nowEvo.image = pokeImg.image
        
        if pokemon.nextEvolutionId != ""  {
            nextEvoImg.hidden = false
            self.nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            self.nextEvo.text = "Next evolution to \(self.pokemon.nextEvolutionTxt)"
            
            if pokemon.nextEvolutionLvl != "" {
                self.nextEvo.text = self.nextEvo.text! + "on LVL \(self.pokemon.nextEvolutionLvl)"
            }
        } else {
            self.nextEvoImg.hidden = true
            self.nextEvo.text = "No evolution"
        }
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
}
