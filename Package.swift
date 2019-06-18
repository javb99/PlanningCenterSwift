// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlanningCenterSwift",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "PlanningCenterSwift",
            targets: ["PlanningCenterSwift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "/Users/josephvanboxtel/Library/CloudStorage/iCloud Drive/Documents/Programming/Projects/ServicesScheduler/ServicesScheduler/generic-json-swift")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "PlanningCenterSwift",
            dependencies: ["GenericJSON"]),
        .testTarget(
            name: "PlanningCenterSwiftTests",
            dependencies: ["PlanningCenterSwift"]),
    ]
)

