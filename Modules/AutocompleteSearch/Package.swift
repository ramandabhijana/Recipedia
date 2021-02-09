// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AutocompleteSearch",
  platforms: [.iOS(.v14), .macOS(.v11)],
  products: [
    .library(
      name: "AutocompleteSearch",
      targets: ["AutocompleteSearch"]),
  ],
  dependencies: [
    .package(path: "../Recipe"),
    .package(name: "Core", url: "https://github.com/abhija-gh/Recipedia-Core.git", from: "1.0.0"),
    .package(name: "Realm", url: "https://github.com/realm/realm-cocoa.git", from: "10.2.0"),
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.0"))
  ],
  targets: [
    .target(
      name: "AutocompleteSearch",
      dependencies: [
        .product(name: "RealmSwift", package: "Realm"),
        "Core",
        "Recipe",
        "Alamofire"
      ]
    ),
    .testTarget(
      name: "AutocompleteSearchTests",
      dependencies: ["AutocompleteSearch"]),
  ]
)
