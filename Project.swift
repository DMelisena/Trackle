import ProjectDescription

let project = Project(
    name: "Trackle",
    targets: [
        .target(
            name: "Trackle",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.Trackle",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["App/Sources/**"],
            resources: ["App/Resources/**"],
            dependencies: [
                .external(name: "HotSwiftUI"),
                // .external(name: "Inject"),
            ],
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": [
                        "$(inherited)", // Always include this to preserve default linker flags
                        "-Xlinker", // Passes the next argument directly to the linker
                        "-interposable", // The actual linker flag
                        // You can add more flags here, each as a separate string element
                        // "-Xlinker", "-some_other_linker_flag",
                        // "-framework", "MyCustomFramework" // Example for linking a framework
                    ],
                    // User defined build setting
                    "EMIT_FRONTEND_COMMAND_LINES": "YES",
                ]
            )

        ),
        .target(
            name: "TrackleTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.TrackleTests",
            infoPlist: .default,
            sources: ["App/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Trackle")]
        ),
    ]
)
