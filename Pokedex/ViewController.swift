//
//  ViewController.swift
//  Pokedex
//
//  Created by Henrique Dourado on 23/04/16.
//  Copyright © 2016 Henrique Dourado. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    
    var pokeSound: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
            collection.delegate = self
            collection.dataSource = self
        
            searchBar.placeholder = "Search for Pokemon"
            searchBar.returnKeyType = .Done
            searchBar.delegate = self
        
            initAudio()
            parsePokemonCSV()
    }
    
    @IBAction func stopMusic(sender: UIButton!) {
        if pokeSound.playing {
            pokeSound.stop()
            sender.alpha = 0.2
        } else {
            pokeSound.play()
            sender.alpha = 1
        }
    }
    
    func initAudio() {
        do {
            try pokeSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!))
            pokeSound.prepareToPlay()
            pokeSound.numberOfLoops = -1
            pokeSound.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let pokeName = row["identifier"]!
                
                pokemons.append(Pokemon(name: pokeName, id: pokeId))
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            collection.reloadData()
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercaseString
            
            filteredPokemons = pokemons.filter({$0.name.rangeOfString(lower) != nil})
            
            collection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemons.count
        } else {
            return 718
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            
            if inSearchMode {
                cell.configureCell(filteredPokemons[indexPath.row])
            } else {
                cell.configureCell(pokemons[indexPath.row])
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemons[indexPath.row]
        } else {
            poke = pokemons[indexPath.row]
        }
        
        performSegueWithIdentifier("goToPokeDetailVC", sender: poke)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToPokeDetailVC" {
            if let vc = segue.destinationViewController as? PokeDetailVC {
                if let poke = sender as? Pokemon {
                    vc.pokemon = poke
                }
            }
        }
    }
    
}

