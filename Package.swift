// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPsd",
    platforms: [
            .macOS(.v13)
        ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
		.package(url: "https://github.com/pvieito/PythonKit.git", .branch("master")),

    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "SwiftPsd",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"), "PythonKit"
            ]
        ),
		.testTarget(
			name: "SwiftPsdTests",
			dependencies: ["SwiftPsd", "PythonKit"],
			resources: [.process("Resources")])
    ]
)
