// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Andromeda",
    platforms: [ .iOS(.v14) ],
    products: [ .library(name: "Andromeda", targets: ["Andromeda"]) ],
    dependencies: [
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire", branch: "master"),
        .package(name: "Pulse", url: "https://github.com/kean/Pulse", branch: "master"),
        .package(name: "SDWebImage", url: "https://github.com/SDWebImage/SDWebImage", branch: "master")
    ],
    targets: [
        .target(name: "Andromeda", dependencies: [ "Alamofire", "Pulse", "SDWebImage" ]),
        .testTarget( name: "AndromedaTests", dependencies: ["Andromeda"])
    ]
)
