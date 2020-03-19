// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "GatewayAPIKit",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "GatewayAPIKit",
            targets: ["GatewayAPIKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "GatewayAPIKit",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ]),
        .testTarget(
            name: "GatewayAPIKitTests",
            dependencies: [
                .target(name: "GatewayAPIKit")
        ]),
    ]
)
