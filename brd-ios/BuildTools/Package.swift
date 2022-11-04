// swift-tools-version:5.5
import PackageDescription


let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v10_13)],
    dependencies: [
        .package(url: "https://github.com/SwiftGen/SwiftGen.git", .exact("6.6.2"))
    ],
    targets: [
        .target(name: "BuildTools",
                path: "",
                resources: [
                  .copy("Resources/swiftgen.yml")
                ]),
    ]
)
