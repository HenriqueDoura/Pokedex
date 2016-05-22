//
//  Pokemon.swift
//  Pokedex
//
//  Created by Henrique Dourado on 23/04/16.
//  Copyright © 2016 Henrique Dourado. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height : String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonURL: String!
  
    var nextEvolutionLvl: String {
        get {
            if _nextEvolutionLvl == nil {
                _nextEvolutionLvl = ""
            }
            return _nextEvolutionLvl
        }
    }
    
    var nextEvolutionTxt: String {
        
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId: String {
        
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var description: String {
        
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, id: Int) {
        self._name = name
        self._pokedexId = id
        
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        Alamofire.request(.GET, _pokemonURL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = String(attack)
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = String(defense)
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0{
                    if types.count > 1 {
                        if let type1 = types[0]["name"], let type2 = types[1]["name"] {
                            self._type = "\(type1.capitalizedString)/\(type2.capitalizedString)"
                        }
                    } else {
                        if let name = types[0]["name"] {
                            self._type = name.capitalizedString
                        }
                    }
                    
                } else {
                    self._type = "No type found"
                }
                
                if let descs = dict["descriptions"] as? [Dictionary<String, String>] {
                    if let descLink = descs[0]["resource_uri"]  {
                        let url = "\(URL_BASE)\(descLink)"
                        
                        Alamofire.request(.GET, url).responseJSON { response in
                            let result = response.result
                            
                            if let dict = result.value as? Dictionary<String, AnyObject> {
                                if let desc = dict["description"] as? String {
                                    self._description = desc
                                    print(self._description)
                                }
                            }
                            
                            completed()
                        }
                    }
                } else {
                    self._description = "No description found"
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String {
                        if to.rangeOfString("mega") == nil {
                            if let url = evolutions[0]["resource_uri"] as? String {
                                let newStr = url.stringByReplacingOccurrencesOfString(URL_POKEMON, withString: "")
                                let id = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutionId = id
                                self._nextEvolutionTxt = to
                                
                                if let nextEvoLvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = String(nextEvoLvl)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}