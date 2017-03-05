import PackageDescription

let package = Package(
    name: "MemexSDK",
    targets: [],
    dependencies: [
      .Package(url: "https://github.com/memexapp/atom.git", majorVersion: 0),
      .Package(url: "https://github.com/memexapp/sushi-swift.git", majorVersion: 0),
      .Package(url: "https://github.com/memexapp/object-mapper.git", majorVersion: 0),
      .Package(url: "https://github.com/memexapp/sushi-swift.git", majorVersion: 0)
    ]
)
