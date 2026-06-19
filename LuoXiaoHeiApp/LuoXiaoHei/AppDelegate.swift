import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 初始化应用层数据
        _ = ConfigManager.shared
        Localization.shared.load(language: ConfigManager.shared.config.language)
        _ = RumorDataStore.shared

        // 创建主窗口
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)

        // 构建根 VC（用 UINavigationController 包装 HomeViewController）
        let home = HomeViewController()
        let nav = UINavigationController(rootViewController: home)
        nav.navigationBar.tintColor = UIColor.systemOrange
        nav.navigationBar.barTintColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)
        nav.navigationBar.isTranslucent = false
        nav.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)
        nav.modalPresentationStyle = .fullScreen

        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
