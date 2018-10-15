//
//  Pokemon.swift
//  pokedex
//
//  Created by Manuel Teixeira on 11/10/2018.
//  Copyright © 2018 Manuel Teixeira. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _pokemonURL: String!
    private var _evolutionURL: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    
    
    // MARK: - Getters
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
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
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        
        return _nextEvolutionText
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        
        return _nextEvolutionLevel
    }
    
    // MARK: - Init
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(BASE_URL)\(POKEMON_URL)\(pokedexId)/"
        self._evolutionURL = "\(BASE_URL)\(EVOLUTION_URL)\(pokedexId)"
    }
    
    // MARK: - API Request
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON {
            (response) in
            
            if let dictionary = response.result.value as? [String : Any] {
                if let weight = dictionary["weight"] as? Int {
                    self._weight = "\(weight)"
                }
                
                if let height = dictionary["height"] as? Int {
                    self._height = "\(height)"
                }
                
                if let types = dictionary["types"] as? [[String : Any]], types.count > 0 {
                    
                    self._type = ""
                    for (index, type) in types.enumerated() {
                        if let type = type["type"] as? [String : Any] {
                            if let name = type["name"] as? String {
                                if (index == 0) {
                                    self._type = name.capitalized
                                } else {
                                    self._type += " / \(name.capitalized)"
                                }
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                if let species = dictionary["species"] as? [String : Any] {
                    if let url = species["url"] as? String {
                        Alamofire.request(url).responseJSON {
                            (response) in
                            if let descriptionDictionary = response.result.value as? [String : Any] {
                                if let descriptionArray = descriptionDictionary["flavor_text_entries"] as? [[String : Any]] {
                                    // Fix to dynamic index
                                    if let description = descriptionArray[1] as? [String : Any] {
                                        if let descriptionText = description["flavor_text"] as? String {
                                            self._description = descriptionText
                                        }
                                    }
                                }
                            }
                            
                            completed()
                        }
                    }
                } else {
                    self._description = ""
                }
                
            }
            
            completed()
        }
        
        print(_evolutionURL)
        
        Alamofire.request(_evolutionURL).responseJSON {
            (response) in
            
            #warning ("TODO: Fix to new API V2")
            if let evolutionDictionary = response.result.value as? [String : Any] {
                if let chain = evolutionDictionary["chain"] as? [String : Any] {
                    if let evolution = chain["evolves_to"] as? [[String : Any]] {
                        if let species = evolution[0]["species"] as? [String : Any] {
                            if let name = species["name"] as? String {
                                self._nextEvolutionName = name
                            }
                            
                            if let url = species["url"] as? String {
                                // Extract the id from the URL
                                let str = url.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
                                self._nextEvolutionId = str.replacingOccurrences(of: "/", with: "")
                            }
                        }
                        
                        if let evolutionDetails = evolution[0]["evolution_details"] as? [[String : Any]] {
                            if let evolutionLevel = evolutionDetails[0]["min_level"] as? Int {
                                self._nextEvolutionLevel = "\(evolutionLevel)"
                            }
                        }
                    }
                }
            }
            
            completed()
        }
    }
}
