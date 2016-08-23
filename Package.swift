import PackageDescription

let package = Package(
    name: "ColorConsoleLogAppender",
    targets: [
        Target(
            name: "AppednerTest",
            dependencies: [.Target(name: "ColorConsoleLogAppender")]),
        Target(
            name: "ColorConsoleLogAppender")
    ],
    dependencies: [
        .Package(url: "https://github.com/Zewo/Log.git", majorVersion: 0, minor: 9),
    ]
)
