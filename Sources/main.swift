//
//  main.swift
//  Example
//
//  Created by Jake Heiser on 6/13/15.
//  Copyright © 2015 jakeheis. All rights reserved.
//

import Foundation
import SwiftCLI

CLI.setup(name: "baker", version: "1.1", description: "Baker - your own personal baker, here to bake you whatever you want")

// MARK: - ChainableCommand example

CLI.registerChainableCommand(name: "init")
    .withShortDescription("Creates a Bakefile in the current or given directory")
    .withSignature("[<directory>]")
    .withExecutionBlock {(arguments) in
        let baseDirectory = arguments.optionalArgument("directory") ?? "."
        let url = URL(fileURLWithPath: baseDirectory).appendingPathComponent("Bakefile")
        
        do {
           try Bakefile.create(url: url)
        } catch {
            throw CLIError.error("The Bakefile was not able to be created")
        }
    }

// MARK: - CommandType examples

CLI.register(command: BakeCommand())

CLI.register(command: RecipeCommand())

// MARK: - LightweightCommand example

func createListCommand() -> Command {
    let listCommand = LightweightCommand(name: "list")
    listCommand.shortDescription = "Lists some possible items the baker can bake for you."
    
    var showExotics = false
    
    listCommand.optionsSetupBlock = {(options) in
        options.add(flags: ["-e", "--exotics-included"]) {
            showExotics = true
        }
    }
    
    listCommand.executionBlock = {(arguments) in
        var foods = ["bread", "cookies", "cake"]
        
        if showExotics {
            foods += ["exotic baker item 1", "exotic baker item 2"]
        }
        
        print("Items that baker can bake for you:")
        
        for i in 0..<foods.count {
            print("\(i+1). \(foods[i])")
        }
    }
    return listCommand
}

CLI.register(command: createListCommand())

// MARK: - Go

let result = CLI.go()
exit(result)
