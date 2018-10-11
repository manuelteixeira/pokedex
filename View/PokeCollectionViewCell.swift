//
//  PokeCollectionViewCell.swift
//  pokedex
//
//  Created by Manuel Teixeira on 11/10/2018.
//  Copyright © 2018 Manuel Teixeira. All rights reserved.
//

import UIKit

class PokeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        nameLabel.text = self.pokemon.name.capitalized
        thumbImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
    
}
