// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RecipeDetail",
  platforms: [.iOS(.v14), .macOS(.v11)],
  products: [
    .library(
      name: "RecipeDetail",
      targets: ["RecipeDetail"]),
  ],
  dependencies: [
    .package(path: "../Recipe"),
    .package(name: "Realm", url: "https://github.com/realm/realm-cocoa.git", from: "10.2.0"),
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.0"))
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "RecipeDetail",
      dependencies: [
        .product(name: "RealmSwift", package: "Realm"),
        "Recipe",
        "Alamofire"
      ]
    ),
    .testTarget(
      name: "RecipeDetailTests",
      dependencies: [
        "RecipeDetail",
      ]),
  ]
)
