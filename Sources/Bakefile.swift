//
//  Bakefile.swift
//  Example
//
//  Created by Jake Heiser on 6/13/15.
//  Copyright © 2015 jakeheis. All rights reserved.
//

import Foundation
import SwiftCLI

class Bakefile {
    
    private var contents: NSMutableDictionary = [:]
    
    var url: URL
    
    static let NotFoundError = CLIError.error("The Bakefile could not be found")
    static let ParsingError = CLIError.error("The Bakefile could not be parsed")
    static let WritingError = CLIError.error("The Bakefile could not be written to")
    
    class func create(url: URL) throws {
        let startingContents = ["items": []]
         
        guard let json = try? JSONSerialization.data(withJSONObject: startingContents, options: .prettyPrinted) else {
            throw Bakefile.WritingError
        }
        
        do {
            try json.write(to: url, options: .atomic)
        } catch _ {
            throw Bakefile.WritingError
        }
    }
    
    init() throws {
        url = URL(fileURLWithPath: "./Bakefile")
        
        guard let data = try? Data(contentsOf: url) else {
            throw Bakefile.NotFoundError
        }
        
        guard let parsedJSON = try? JSONSerialization.jsonObject(with: data, options: []) else {
            throw Bakefile.ParsingError
        }
        
        guard let immutableBakefile = parsedJSON as? NSDictionary else {
            throw Bakefile.ParsingError
        }
        
        guard let bakefileContents = immutableBakefile.mutableCopy() as? NSMutableDictionary else {
            throw Bakefile.ParsingError
        }
        
        contents = bakefileContents
    }
    
    func items() throws -> [String] {
        guard let items = contents["items"] as? [String] else {
            throw Bakefile.ParsingError
        }
        
        return items
    }
    
    func customRecipes() throws -> [NSDictionary] {
        guard let customRecipes = contents["custom_recipes"] as? [NSDictionary] else {
            throw Bakefile.ParsingError
        }
        
        return customRecipes
    }

    func addRecipe(_ recipe: NSDictionary) throws {
        var customRecipes: [NSDictionary] = contents["custom_recipes"] as? [NSDictionary] ?? []
        customRecipes.append(recipe)
        contents["custom_recipes"] = customRecipes
        
        try save()
    }
    
    func save() throws {
        guard let finalData = try? JSONSerialization.data(withJSONObject: contents, options: .prettyPrinted) else {
            throw Bakefile.WritingError
        }
        do {
            try finalData.write(to: url, options: .atomic)
        } catch _ {
            throw Bakefile.WritingError
        }
    }
    
}
