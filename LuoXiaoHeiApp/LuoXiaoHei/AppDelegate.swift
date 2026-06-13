import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 初始化应用层数据
        _ = ConfigManager.shared
        Localization.shared.load(language: ConfigManager.shared.config.language)
        RumorDataStore.shared

        // 构建根 VC
        let home = HomeViewController()
        let nav = UINavigationController(rootViewController: home)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.tintColor = ThemeManager.shared.accent
        nav.overrideUserInterfaceStyle = ThemeManager.shared.isDark ? .dark : .light

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        window.overrideUserInterfaceStyle = ThemeManager.shared.isDark ? .dark : .light
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    // MARK: UISceneSession Lifecycle（iOS 13+，避免 Info.plist 里声明 Scene 又没实现而崩溃）
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        _ = ConfigManager.shared
        Localization.shared.load(language: ConfigManager.shared.config.language)
        RumorDataStore.shared

        let home = HomeViewController()
        let nav = UINavigationController(rootViewController: home)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.tintColor = ThemeManager.shared.accent
        nav.overrideUserInterfaceStyle = ThemeManager.shared.isDark ? .dark : .light

        let w = UIWindow(windowScene: windowScene)
        w.rootViewController = nav
        w.overrideUserInterfaceStyle = ThemeManager.shared.isDark ? .dark : .light
        w.makeKeyAndVisible()
        self.window = w
    }
}
