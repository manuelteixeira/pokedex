//
//  PokemonDetailViewController.swift
//  pokedex
//
//  Created by Manuel Teixeira on 12/10/2018.
//  Copyright © 2018 Manuel Teixeira. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pokedexIDLabel: UILabel!
    @IBOutlet weak var baseAttackLabel: UILabel!
    @IBOutlet weak var currentEvolutionImage: UIImageView!
    @IBOutlet weak var nextEvolutionImage: UIImageView!
    @IBOutlet weak var evolutionLabel: UILabel!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = pokemon.name
        let image = UIImage(named: "\(pokemon.pokedexId)")
        mainImage.image = image
        currentEvolutionImage.image = image
        
        pokedexIDLabel.text = "\(pokemon.pokedexId)"
        
        pokemon.downloadPokemonDetail {
            self.updateUI()
        }
    }
    
    func updateUI() {
        weightLabel.text = pokemon.weight
        heightLabel.text = pokemon.height
        typeLabel.text = pokemon.type
        descriptionLabel.text = pokemon.description
        evolutionLabel.text = "\(pokemon.nextEvolutionName.capitalized) LVL \(pokemon.nextEvolutionLevel)"
        nextEvolutionImage.image = UIImage(named: pokemon.nextEvolutionId)
    }

}
