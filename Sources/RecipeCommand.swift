//
//  RecipeCommand.swift
//  Example
//
//  Created by Jake Heiser on 8/17/14.
//  Copyright (c) 2014 jakeheis. All rights reserved.
//

import Foundation
import SwiftCLI

class RecipeCommand: Command {
    
    let name = "recipe"
    let shortDescription = "Creates a recipe interactively"
    
    func execute() throws {
        let bakefile = try Bakefile()
        
        let recipe: [String: Any]
        
        let name = Input.awaitInput(message: "Name of your recipe: ")
        let cookTime = Input.awaitInt(message: "Cook time: ")
        let silently = Input.awaitYesNoInput(message: "Bake silently?")
        
        recipe = ["name": name, "cookTime": cookTime, "silently": silently]
        
        try bakefile.addRecipe(recipe as NSDictionary)
    }
   
}
