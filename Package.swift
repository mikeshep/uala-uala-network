// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UalaNetwork",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "UalaNetwork",
            targets: ["UalaNetwork"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "13.0.0"))
            
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "UalaNetwork",
            dependencies: [.product(name: "RxMoya", package: "Moya")]),
        .testTarget(
            name: "UalaNetworkTests",
            dependencies: ["UalaNetwork", .product(name: "RxMoya", package: "Moya")]),
    ]
)
