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

        // 强制获取屏幕真实大小（覆盖整个屏幕）
        let screenBounds = UIScreen.main.bounds

        // 创建主窗口 —— 明确指定全屏大小
        let window = UIWindow(frame: screenBounds)
        window.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)
        window.windowLevel = .normal
        window.isHidden = false

        // 直接用 HomeViewController 作为 rootViewController（不包在 UINavigationController 中）
        let home = HomeViewController()
        window.rootViewController = home

        // 确保 window 在最上层并可见
        window.makeKeyAndVisible()
        self.window = window

        // 强制立即布局，确保 view 正确覆盖整个屏幕
        DispatchQueue.main.async {
            home.view.setNeedsLayout()
            home.view.layoutIfNeeded()
        }

        return true
    }
}
