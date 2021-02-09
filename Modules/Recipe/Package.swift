// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Recipe",
  platforms: [.iOS(.v14), .macOS(.v11)],
  products: [
    .library(
      name: "Recipe",
      targets: ["Recipe"]),
  ],
  dependencies: [
    .package(name: "Realm", url: "https://github.com/realm/realm-cocoa.git", from: "10.2.0"),
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.0")),
    .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.7.0"),
    .package(name: "Core", url: "https://github.com/abhija-gh/Recipedia-Core.git", from: "1.0.0")
  ],
  targets: [
    .target(
      name: "Recipe",
      dependencies: [
        .product(name: "RealmSwift", package: "Realm"),
        "Core",
        "Alamofire",
        "SDWebImage"
      ]
    ),
    .testTarget(
      name: "RecipeTests",
      dependencies: ["Recipe"]),
  ]
)
