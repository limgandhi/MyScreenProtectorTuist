import ProjectDescription
import Foundation

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform, additionalTargets: [String]) -> Project {
        var targets = makeAppTargets(name: name,
                                     platform: platform,
                                     dependencies: additionalTargets.map { TargetDependency.target(name: $0) })
        targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, platform: platform) })
        return Project(name: name,
                       organizationName: "myscreenprotector.org",
                       targets: targets)
    }

    // MARK: - Private

    private static func getBundleIdBase(_ name: String) -> String {
        let lowercasedName = name.lowercased()
        return "org.myscreenprotector.\(lowercasedName)-\(NSUserName())"
    }
    
    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, platform: Platform) -> [Target] {
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UILaunchStoryboardName": "LaunchScreen",
            "UIApplicationSceneManifest" : ["UIApplicationSupportsMultipleScenes":true,
                                            "UISceneConfigurations":[
                                                "UIWindowSceneSessionRoleApplication":[[
                                                    "UISceneConfigurationName":"Default Configuration",
                                                    "UISceneDelegateClassName":"$(PRODUCT_MODULE_NAME).SceneDelegate",
                                                    "UISceneStoryboardFile":"Main"
                                                ]]
                                            ]
                                           ]
        ]
        
        let sources = Target(name: name,
                platform: platform,
                product: .framework,
                bundleId: getBundleIdBase(name),
                infoPlist: .extendingDefault(with: infoPlist),
                sources: ["Targets/\(name)/Sources/**"],
                resources: [],
                dependencies: [])
        let tests = Target(name: "\(name)Tests",
                platform: platform,
                product: .unitTests,
                bundleId: getBundleIdBase(name),
                infoPlist: .default,
                sources: ["Targets/\(name)/Tests/**"],
                resources: [],
                dependencies: [.target(name: name)])
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UILaunchStoryboardName": "LaunchScreen",
            "UIApplicationSceneManifest" : ["UIApplicationSupportsMultipleScenes":true,
                                            "UISceneConfigurations":[
                                                "UIWindowSceneSessionRoleApplication":[[
                                                    "UISceneConfigurationName":"Default Configuration",
                                                    "UISceneDelegateClassName":"$(PRODUCT_MODULE_NAME).SceneDelegate",
                                                    "UISceneStoryboardFile":"Main"
                                                ]]
                                            ]
                                           ]
        ]

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: getBundleIdBase(name),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: getBundleIdBase(name),
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        return [mainTarget, testTarget]
    }
}
