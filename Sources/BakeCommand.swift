//
//  BakeCommand.swift
//  Example
//
//  Created by Jake Heiser on 8/1/14.
//  Copyright (c) 2014 jakeheis. All rights reserved.
//

import Foundation
import SwiftCLI

class BakeCommand: Command {

    let name = "bake"
    let shortDescription = "Bakes the items in the Bakefile"

    let item = OptionalParameter()
    
    let quickly = Flag("-q", "--quickly", usage: "Bake more quickly")
    let silently = Flag("-s", "--silently", usage: "Bake silently")
    let topping = Key<String>("-t", "--with-topping", usage: "Adds a topping to the baked good")

    func execute() throws  {
        if let item = item.value {
            bakeItem(item)
        } else {
            let items = try loadBakefileItems()

            for item in items {
                bakeItem(item)
            }
        }
    }

    // MARK: - Baking

    private func bakeItem(_ item: String) {
        let quicklyStr = quickly.value ? " quickly" : ""
        let toppingStr = topping.value == nil ? "" : " topped with \(topping.value!)"

        print("Baking a \(item)\(quicklyStr)\(toppingStr)")

        let recipe = checkForRecipe(item: item)
        var cookTime: Int
        var cookSilently: Bool
        if let recipe = recipe {
            cookTime = recipe["cookTime"] as? Int ?? 4
            cookSilently = recipe["silently"] as? Bool ?? silently.value
        } else {
            cookTime = 4
            cookSilently = silently.value
        }

        if quickly.value {
            cookTime = cookTime/2
        }
        
        for _ in 0..<cookTime {
            Thread.sleep(forTimeInterval: 1)
            if !cookSilently {
                print("...")
            }
        }

        print("Your \(item) is now ready!")
    }

    private func checkForRecipe(item: String) -> NSDictionary? {
        do {
            let recipes = try loadBakefileRecipes()

            for recipe in recipes {
                if recipe["name"] as? String == item {
                    return recipe
                }
            }
        } catch {
            return nil
        }

        return nil
    }

    // MARK: - Loading

    private func loadBakefileItems() throws -> [String] {
        let bakefile = try Bakefile()
        let items = try bakefile.items()

        return items
    }

    private func loadBakefileRecipes() throws -> [NSDictionary] {
        let bakefile = try Bakefile()
        let recipes = try bakefile.customRecipes()

        return recipes
    }

}
