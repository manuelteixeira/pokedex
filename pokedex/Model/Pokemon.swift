//
//  Pokemon.swift
//  pokedex
//
//  Created by Manuel Teixeira on 11/10/2018.
//  Copyright © 2018 Manuel Teixeira. All rights reserved.
//

import Foundation

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    
    // Getters
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
}
