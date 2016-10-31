//
//  Pokemon.swift
//  Pokedex
//
//  Created by Jared Nielson on 10/27/16.
//  Copyright © 2016 Jared Nielson. All rights reserved.
//

import Foundation


class Pokemon {
    
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    
    
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
