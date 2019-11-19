// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "GatewayAPIKit",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "GatewayAPIKit",
            targets: ["GatewayAPIKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "GatewayAPIKit",
            dependencies: ["AsyncHTTPClient", "NIOFoundationCompat"]),
        .testTarget(
            name: "GatewayAPIKitTests",
            dependencies: ["GatewayAPIKit"]),
    ]
)
