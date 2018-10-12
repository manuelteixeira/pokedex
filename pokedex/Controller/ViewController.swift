//
//  ViewController.swift
//  pokedex
//
//  Created by Manuel Teixeira on 11/10/2018.
//  Copyright © 2018 Manuel Teixeira. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        // Toggle play - pause
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var inSearchMode = false
    var musicPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchBar.delegate = self
        // Change the return key text to "Done"
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        
        initAudio()
    }
    
    func initAudio() {
        if let path = Bundle.main.path(forResource: "music", ofType: "mp3") {
            do {
                if let musicURL = URL(string: path) {
                    musicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                    musicPlayer.prepareToPlay()
                    // Loop forever
                    musicPlayer.numberOfLoops = -1
                    musicPlayer.play()
                }
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
    }
    
    func parsePokemonCSV() {
        // Get the file
        if let path = Bundle.main.path(forResource: "pokemon", ofType: "csv") {
            print(path)
            do {
                let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                
                for row in rows {
                    let pokeId = Int(row["id"]!)!
                    let name = row["identifier"]!
                    let pokemon = Pokemon(name: name, pokedexId: pokeId)
                    pokemons.append(pokemon)
                }
                
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemons.count
        }
        
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCollectionViewCell", for: indexPath) as? PokeCollectionViewCell {
            
            let pokemon: Pokemon!
            
            if inSearchMode {
                pokemon = filteredPokemons[indexPath.row]
            } else {
                pokemon = pokemons[indexPath.row]
            }
            
            cell.configureCell(pokemon: pokemon)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var pokemon: Pokemon!
        
        if inSearchMode {
            pokemon = filteredPokemons[indexPath.row]
        } else {
            pokemon = pokemons[indexPath.row]
        }
        
        performSegue(withIdentifier: "showPokemonDetailViewController", sender: pokemon)
    }
    
    // Define the size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    
    // Search for pokemon
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty) {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            let lower = searchText.lowercased()
            
            filteredPokemons = pokemons.filter({$0.name.range(of: lower) != nil})
            collectionView.reloadData()
        }
    }
    
    // When enter is tapped on keyboard hide it
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPokemonDetailViewController" {
            if let pokemonDetailViewController = segue.destination as? PokemonDetailViewController {
                if let pokemon = sender as? Pokemon {
                    pokemonDetailViewController.pokemon = pokemon
                }
            }
        }
    }
}

