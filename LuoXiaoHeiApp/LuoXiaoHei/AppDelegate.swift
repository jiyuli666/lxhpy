import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 初始化应用层数据
        _ = ConfigManager.shared
        Localization.shared.load(language: ConfigManager.shared.config.language)
        RumorDataStore.shared.reload()

        // 创建主窗口
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = ThemeManager.shared.background

        // 用 UINavigationController 包装 HomeViewController
        let home = HomeViewController()
        let nav = UINavigationController(rootViewController: home)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.tintColor = ThemeManager.shared.accent
        nav.overrideUserInterfaceStyle = ThemeManager.shared.isDark ? .dark : .light
        nav.view.backgroundColor = ThemeManager.shared.background

        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
