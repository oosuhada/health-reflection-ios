// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(productTypes: [:])
#endif

let package = Package(
    name: "HealthReflectionDependencies",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            .upToNextMajor(from: "0.52.0")
        ),
        .package(
            url: "https://github.com/airbnb/lottie-ios.git",
            .upToNextMajor(from: "4.0.0")
        ),
    ]
)
