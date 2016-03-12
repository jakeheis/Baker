import PackageDescription

let package = Package(
    name: "Baker",
    dependencies: [
        .Package(url: "https://github.com/jakeheis/SwiftCLI", majorVersion: 1, minor: 2)
    ]
)