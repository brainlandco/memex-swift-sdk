import PackageDescription

let package = Package(
    name: "Core",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1),
    ]
)
