//
//  MainVC.swift
//  Pokedex
//
//  Created by Jared Nielson on 10/27/16.
//  Copyright © 2016 Jared Nielson. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        //When the done botton is clicked on the keyboard it will close the keyboard
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio() {
        
        //Gets the path to the music file
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            //-1 for number of loops will make it play continously
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        
        //Creates a path to the pokemon.csv file
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            //Uses the parser to pull out the rows
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            //Gets the pokeId and name in each row
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
            //Creates a pokemon object and then passes it into the array created above
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    
    
    //This fuction dequeues the cells so that all 718 images are not trying to be loaded at the same time.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            
            
            if inSearchMode {
                
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            } else {
            
            poke = pokemon[indexPath.row]
            cell.configureCell(poke)
            
            }
            return cell
            
        } else {
    
            return UICollectionViewCell()
        }
    }
    
    
    //This will execute the code whenever an item in the collection view is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    var poke: Pokemon!
    
    if inSearchMode {
    
        poke = filteredPokemon[indexPath.row]
    
    } else {
    
        poke = pokemon[indexPath.row]
    }
    
    performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    
    
    }
    
    
    //Sets the number of items in the section
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection: Int) -> Int {
            
            if inSearchMode {
                
                return filteredPokemon.count
                
            } else {
            
            return pokemon.count
                
            }
        }
    
    //Sets the number of sections in the collection view
        @objc(numberOfSectionsInCollectionView:) func numberOfSections(in: UICollectionView) -> Int {
            
            return 1
        }
    
    
    //Sets the size of the cells in the collection view
        func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
            
            return CGSize(width: 105, height: 105)
            
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
            
        } else {
            
            inSearchMode = true
            
            //creates a variable called lower that stores and changes all text entered into the search bar to lowercase
            let lower = searchBar.text!.lowercased()
            
            //This takes the pokemon array and searches through the names of them to see if any of them match contain the same characters that are stored in the lower variable. $0 is a place holder for each item contained in the array.
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil })
            collection.reloadData()
        }
        
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
        }
    
    //When ever the done button is pressed on the keyboard it will close the keyboard screen
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
        
    }
    
}

