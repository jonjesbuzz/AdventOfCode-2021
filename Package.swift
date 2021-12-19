// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
//        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "AdventCore"),
        .executableTarget(name: "Dive", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "BinaryDiagnostic", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "GiantSquid", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "CrabSubmarine", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "HydrothermalVent", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "Lanternfish", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "SegmentSearch", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "SmokeBasin", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "SyntaxScoring", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "DumboOctopus", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "PassagePathing", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "TransparentOrigami", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "Polymerization", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "Chiton", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "PacketDecoder", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "TrickShot", dependencies: [
            .target(name: "AdventCore")
        ]),
        .executableTarget(name: "Snailfish", dependencies: [
            .target(name: "AdventCore")
        ]),
        .testTarget(
            name: "AdventOfCodeTests",
            dependencies: ["AdventCore"]),
    ]
)
