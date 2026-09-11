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
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        // Clang-only. Do not set path to the package root — SPM then sees
        // FlutterXmppPlugin.swift plus these .m files and fails with
        // "contains mixed language source files".
        .target(
            name: "flutter_xmpp_core",
            exclude: [
                "xmppframework/Vendor/KissXML/DDXML.swift",
                "xmppframework/Vendor/CocoaLumberjack/Extensions/README.txt",
                "xmppframework/ORIGIN.md",
                "xmppframework/README.markdown",
                "xmppframework/copying.txt",
                "xmppframework/Vendor/libidn/build-libidn.sh",
            ],
            sources: [
                "engine",
                "libidn_stub",
                "xmppframework/Core",
                "xmppframework/Authentication",
                "xmppframework/Categories",
                "xmppframework/Utilities",
                "xmppframework/Extensions/Reconnect",
                "xmppframework/Extensions/XEP-0199",
                "xmppframework/Vendor/CocoaAsyncSocket",
                "xmppframework/Vendor/KissXML",
                "xmppframework/Vendor/CocoaLumberjack",
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include"),
                .headerSearchPath("xmppframework"),
                .headerSearchPath("xmppframework/Core"),
                .headerSearchPath("xmppframework/Authentication"),
                .headerSearchPath("xmppframework/Authentication/Anonymous"),
                .headerSearchPath("xmppframework/Authentication/Digest-MD5"),
                .headerSearchPath("xmppframework/Authentication/Plain"),
                .headerSearchPath("xmppframework/Authentication/SCRAM-SHA-1"),
                .headerSearchPath("xmppframework/Authentication/Deprecated-Plain"),
                .headerSearchPath("xmppframework/Authentication/Deprecated-Digest"),
                .headerSearchPath("xmppframework/Authentication/X-Facebook-Platform"),
                .headerSearchPath("xmppframework/Authentication/X-OAuth2-Google"),
                .headerSearchPath("xmppframework/Categories"),
                .headerSearchPath("xmppframework/Utilities"),
                .headerSearchPath("xmppframework/Extensions/Reconnect"),
                .headerSearchPath("xmppframework/Extensions/XEP-0199"),
                .headerSearchPath("xmppframework/Extensions/Roster"),
                .headerSearchPath("xmppframework/Extensions/Roster/MemoryStorage"),
                .headerSearchPath("xmppframework/Extensions/Roster/CoreDataStorage"),
                .headerSearchPath("xmppframework/Extensions/XEP-0045"),
                .headerSearchPath("xmppframework/Extensions/XEP-0045/MemoryStorage"),
                .headerSearchPath("xmppframework/Extensions/XEP-0045/CoreDataStorage"),
                .headerSearchPath("xmppframework/Extensions/XEP-0045/HybridStorage"),
                .headerSearchPath("xmppframework/Extensions/CoreDataStorage"),
                .headerSearchPath("xmppframework/Vendor/CocoaAsyncSocket"),
                .headerSearchPath("xmppframework/Vendor/KissXML"),
                .headerSearchPath("xmppframework/Vendor/KissXML/Additions"),
                .headerSearchPath("xmppframework/Vendor/KissXML/Categories"),
                .headerSearchPath("xmppframework/Vendor/KissXML/Private"),
                .headerSearchPath("xmppframework/Vendor/CocoaLumberjack"),
                .headerSearchPath("xmppframework/Vendor/CocoaLumberjack/Extensions"),
                .headerSearchPath("xmppframework/Vendor/libidn"),
            ],
            linkerSettings: [
                .linkedLibrary("xml2"),
                .linkedLibrary("resolv"),
                .linkedFramework("CFNetwork"),
                .linkedFramework("Security"),
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("CoreData"),
            ]
        ),
        .target(
            name: "flutter_xmpp",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                "flutter_xmpp_core",
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
