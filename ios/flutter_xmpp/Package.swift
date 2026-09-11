// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "flutter_xmpp",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "flutter-xmpp", targets: ["flutter_xmpp"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/robbiehanson/XMPPFramework.git", branch: "master"),
    ],
    targets: [
        .target(
            name: "flutter_xmpp",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "XMPPFramework", package: "XMPPFramework"),
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
