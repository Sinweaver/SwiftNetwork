// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftNetwork",
    platforms: [
        .iOS(.v10),
        .tvOS(.v10)],
    products: [
        .library(
            name: "SwiftNetwork",
            targets: ["SwiftNetwork"]),
    ],
    targets: [
        .target(
            name: "SwiftNetwork",
            dependencies: [],
	    path: "Sources")
    ],
    swiftLanguageVersions: [.v5]
)
