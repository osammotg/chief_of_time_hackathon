// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SpeedometerHUD",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "SpeedometerHUD",
            targets: ["SpeedometerHUD"]
        )
    ],
    targets: [
        .executableTarget(
            name: "SpeedometerHUD",
            path: "SpeedometerHUD"
        )
    ]
) 