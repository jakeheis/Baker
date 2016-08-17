import PackageDescription

let package = Package(
    name: "Baker",
    dependencies: [
        .Package(url: "https://github.com/jakeheis/SwiftCLI", Version(1, 3, 0, prereleaseIdentifiers: ["beta"]))
    ]
)